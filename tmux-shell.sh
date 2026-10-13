#!/bin/sh
# tmuxのシェル起動ラッパー
# macではpwshのcwd追従とNoLogoを両立する
# それ以外ではログインシェルを起動（tmux標準と同じ）
if [ "$(uname)" = Darwin ]; then
  for p in "$(command -v pwsh 2>/dev/null)" /opt/homebrew/bin/pwsh /usr/local/bin/pwsh; do
    [ -n "$p" ] && [ -x "$p" ] && exec "$p" -Login -NoLogo "$@"
  done
fi
# tmuxはSHELLをdefault-shell（このスクリプト）に書き換えるので、ユーザーDBから引く
sh_=$(getent passwd "$(id -un)" 2>/dev/null | cut -d: -f7)
[ -z "$sh_" ] && sh_=$(dscl . -read "/Users/$(id -un)" UserShell 2>/dev/null | awk '{print $2}')
exec "${sh_:-/bin/sh}" -l "$@"
