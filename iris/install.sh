#!/bin/bash
# iris（ノートPC流用自宅サーバー）用の設定をシステムに反映する
# 何度実行しても同じ結果になる（冪等）
set -euo pipefail

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SUDO=""
[ "$(id -u)" -ne 0 ] && SUDO="sudo"

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
