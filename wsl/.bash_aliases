# ~/.bash_aliases

# alertコマンド
# usage: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# lsなどの色付き出力の有効化
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls -FG --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alhF'
alias la='ls -AF'
alias l='ls -CF'
alias diff='colordiff -uwB'
alias gitlog='git log --decorate --oneline --graph'

# Windows環境との統合
alias cmd='cmd.exe /c'
alias ii='pwsh.exe -Command ii'
alias type='cat'
alias dir='pwsh.exe dir'
function pwsh () {
  if [ $# -eq 0 ];then
    pwsh.exe
  else
    pwsh.exe -Command $@
  fi
}

# その他Windowsコマンド
alias msbuild='msbuild.exe'
alias fasm='fasm.exe'

alias nik='vim ~/wh/OneDrive/doc/nikki'

