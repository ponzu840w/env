# ~/.bashrc @macbook

if [ -z "$PS1" ]; then return; fi

# プロンプト設定
# user@host(通常シアン):path(通常色)
# $(通常シアン)
PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[00m\]\w\n\[\033[36m\]\\$ \[\033[00m\]"

# GNU tools
p="/opt/homebrew/opt"
b="libexec/gnubin"
m="libexec/gnuman"
# coreutils
if [[ ":$PATH:" != *":$p/coreutils/$b:"* ]]; then
  export PATH="$p/coreutils/$b:$PATH"; fi
if [[ ":$MANPATH:" != *":$p/coreutils/$m:"* ]]; then
  export MANPATH="$p/coreutils/$m:$MANPATH"; fi
# findutils
if [[ ":$PATH:" != *":$p/findutils/$b:"* ]]; then
  export PATH="$p/findutils/$b:$PATH"; fi
if [[ ":$MANPATH:" != *":$p/findutils/$m:"* ]]; then
  export MANPATH="$p/findutils/$m:$MANPATH"; fi
unset p b m

# history
export HISTSIZE=5000
export HISTFILESIZE=5000000000000000        # 履歴5000兆件欲しい！
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "  # historyで日付見れる
export HISTCONTROL=ignoreboth:erasedups     # 重複・スペース始まりコマンドを不記録
export PROMPT_COMMAND="history -a"          # 履歴の都度書き込み・読み込まない
shopt -s histappend                         # .bash_historyは追記する

# ls colors
eval `dircolors ~/.colorrc`

# alias
alias ls='ls -FG --color=auto'
alias ll='ls -lhFG --color=auto'
alias la='ls -AFG'
alias l='ls -CFG'

alias ii='open'

# clip.exeのエミュレーション
function clip() {
  if [ -t 0 ]; then
    # TTY入力である -> ストリーム入力がないパイプ先頭
    #   -> クリップボードの中身をストリームに放出
    pbpaste
  else
    # TTY入力でない -> ストリーム入力があるパイプライン後段
    #   -> 入力をクリップボードに保存
    pbcopy
  fi
}

alias nik='vim /Users/ponzu840w/.od/doc/nikki'

alias tcc="wine /Users/ponzu840w/Desktop/tcc/tcc.exe"
alias windres="i686-w64-mingw32-windres"
alias mingw="i686-w64-mingw32-gcc"
alias mingw64="x86_64-w64-mingw32-gcc"
alias xpra="/Applications/Xpra.app/Contents/MacOS/Xpra"

#eval "$(starship init bash)"
export BLOG_ROOT="/Users/ponzu840w/work/bbr/data-test"
export PATH="$PATH:~/work/bbr/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ponzu840w/.lmstudio/bin"
# End of LM Studio CLI section

