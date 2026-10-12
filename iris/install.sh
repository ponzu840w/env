#!/bin/bash
# iris（ノートPC流用自宅サーバー）用の設定をシステムに反映する
# 何度実行しても同じ結果になる（冪等）
set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"
USER_NAME="ponzu840w"
USER_HOME="$(getent passwd "$USER_NAME" | cut -d: -f6)"

# $1: リポジトリ内の相対パス（etc/... → /etc/... に配置）
# 内容が異なる場合のみ配置し、変更があれば0を返す
install_file() {
  local rel="$1" dst="/$1"
  if [ -f "$dst" ] && cmp -s "$SRC_DIR/$rel" "$dst"; then
    echo "[skip] $dst"
    return 1
  fi
  $SUDO install -D -m 644 -o root -g root "$SRC_DIR/$rel" "$dst"
  echo "[install] $dst"
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
