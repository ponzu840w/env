#!/bin/bash
# iris（ノートPC流用自宅サーバー）用の設定をシステムに反映する
# 何度実行しても同じ結果になる（冪等）
set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
USER_NAME="ponzu840w"
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"

# $1: リポジトリ内の相対パス（etc/... → /etc/... に配置）, $2: パーミッション（省略時 644）
# 内容が異なる場合のみ配置し、変更があれば0を返す
install_file() {
  local rel="$1" dst="/$1" mode="${2:-644}"
  if [ -f "$dst" ] && cmp -s "$SRC_DIR/$rel" "$dst"; then
    echo "[skip] $dst"
    return 1
  fi
  $SUDO install -D -m "$mode" -o root -g root "$SRC_DIR/$rel" "$dst"
  echo "[install] $dst"
}

# 未インストールのパッケージだけを入れる（初回のみ apt-get update する）
APT_UPDATED=""
ensure_pkg() {
  local missing=() p
  for p in "$@"; do
    dpkg-query -W -f='${Status}' "$p" 2>/dev/null | grep -q 'install ok installed' || missing+=("$p")
  done
  [ ${#missing[@]} -eq 0 ] && return 0
  if [ -z "$APT_UPDATED" ]; then
    $SUDO apt-get update
    APT_UPDATED=1
  fi
  $SUDO apt-get install -y "${missing[@]}"
}

# ===== フタを閉じてもサスペンドしない =====
if install_file etc/systemd/logind.conf.d/10-lid-ignore.conf; then
  # SIGHUPで設定を再読み込み（restartと違いセッションは切れない）
  $SUDO systemctl kill -s HUP systemd-logind
  sleep 1
fi
for prop in HandleLidSwitch HandleLidSwitchExternalPower HandleLidSwitchDocked; do
  val=$(busctl get-property org.freedesktop.login1 /org/freedesktop/login1 \
        org.freedesktop.login1.Manager "$prop" | awk '{print $2}')
  echo "  $prop=$val"
  [ "$val" = '"ignore"' ] || { echo "ERROR: $prop が ignore になっていません" >&2; exit 1; }
done

# ===== セキュリティ更新の自動適用 =====
ensure_pkg unattended-upgrades
install_file etc/apt/apt.conf.d/20auto-upgrades || true
$SUDO systemctl enable --now apt-daily.timer apt-daily-upgrade.timer
apt_conf=$(apt-config dump)  # パイプで grep -q すると SIGPIPE で誤判定するため変数に受ける
for kv in 'APT::Periodic::Update-Package-Lists "1";' 'APT::Periodic::Unattended-Upgrade "1";'; do
  grep -qxF "$kv" <<<"$apt_conf" || { echo "ERROR: apt の実効値が '$kv' になっていません" >&2; exit 1; }
  echo "  $kv"
done

# ===== SSH: 公開鍵認証のみ =====
# authorized_keys はリポジトリの内容で上書きする
ak_src="$SRC_DIR/home/authorized_keys"
ak_dst="$USER_HOME/.ssh/authorized_keys"
if $SUDO test -f "$ak_dst" && $SUDO cmp -s "$ak_src" "$ak_dst"; then
  echo "[skip] $ak_dst"
else
  $SUDO install -d -m 700 -o "$USER_NAME" -g "$USER_NAME" "$USER_HOME/.ssh"
  $SUDO install -m 600 -o "$USER_NAME" -g "$USER_NAME" "$ak_src" "$ak_dst"
  echo "[install] $ak_dst"
fi

# 有効な鍵が1つもなければパスワード認証を残す（締め出し防止）
if ! ssh-keygen -l -f "$ak_src" >/dev/null 2>&1; then
  echo "WARN: $ak_src に有効な公開鍵がないため、パスワード認証の無効化をスキップします" >&2
elif install_file etc/ssh/sshd_config.d/10-pubkey-only.conf; then
  $SUDO sshd -t
  # ssh.socket による起動待ちの場合は、次回起動時に新しい設定が読まれる
  if systemctl is-active -q ssh.service; then
    $SUDO systemctl reload ssh.service
  fi
fi
if [ -f /etc/ssh/sshd_config.d/10-pubkey-only.conf ]; then
  # 一旦変数に受ける（パイプで grep -q すると pipefail 下で SIGPIPE により誤判定する）
  sshd_conf=$($SUDO sshd -T)
  for kv in "passwordauthentication no" "kbdinteractiveauthentication no" "permitrootlogin no"; do
    grep -qx "$kv" <<<"$sshd_conf" || { echo "ERROR: sshd の実効値が '$kv' になっていません" >&2; exit 1; }
    echo "  $kv"
  done
fi

# ===== ファイアウォール（nftables） =====
# 旧来の iptables-persistent とは併用しない
ensure_pkg nftables
$SUDO nft -c -f "$SRC_DIR/etc/nftables.conf"
install_file etc/nftables.conf 755 || true
$SUDO systemctl enable nftables.service
# restart/stop は ExecStop の flush ruleset で tailscaled のルールまで消すため使わない
if systemctl is-active -q nftables.service; then
  $SUDO systemctl reload nftables.service
else
  $SUDO systemctl start nftables.service
fi
nft_input=$($SUDO nft list chain inet iris input 2>/dev/null || true)
grep -q 'policy drop' <<<"$nft_input" || { echo "ERROR: nftables の inet iris が読み込まれていません" >&2; exit 1; }
echo "  nftables: inet iris (input policy drop)"

# ===== SMART 監視と ntfy 通知 =====
ensure_pkg smartmontools curl
if install_file etc/smartd.conf; then
  $SUDO systemctl restart smartmontools.service
fi
install_file etc/smartmontools/run.d/50ntfy 755 || true
# 通知先トピックは秘密扱い（リポジトリに入れない）。未作成なら推測困難な名前で作る
if ! $SUDO test -f /etc/iris-ntfy.env; then
  topic="iris-$(od -An -N8 -tx1 /dev/urandom | tr -d ' \n')"
  echo "NTFY_TOPIC=$topic" | $SUDO install -m 600 -o root -g root /dev/stdin /etc/iris-ntfy.env
  echo "[create] /etc/iris-ntfy.env"
  # 秘密なので表示は作成時のみ（再確認: sudo cat /etc/iris-ntfy.env）
  echo "  ntfy トピック: $topic（ntfy アプリで購読する）"
else
  echo "[skip] /etc/iris-ntfy.env"
fi
