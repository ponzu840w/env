#!/bin/sh
# tmuxのシェル起動ラッパー
# pwshのcwd追従とNoLogoを両立する
for p in "$(command -v pwsh 2>/dev/null)" /opt/homebrew/bin/pwsh /usr/local/bin/pwsh /usr/bin/pwsh; do
  [ -n "$p" ] && [ -x "$p" ] && exec "$p" -Login -NoLogo "$@"
done
exec "${SHELL:-/bin/sh}" "$@"
