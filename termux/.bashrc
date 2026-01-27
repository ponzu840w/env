# ~/.bashrc @termux

if [ -z "$PS1" ]; then return; fi

# プロンプト設定
# user@host(通常シアン):path(通常色)
# $(通常シアン)
PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[00m\]\w\n\[\033[36m\]\\$ \[\033[00m\]"

# history
export HISTSIZE=5000
export HISTFILESIZE=5000000000000000        # 履歴5000兆件欲しい！
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "  # historyで日付見れる
export HISTCONTROL=ignoreboth:erasedups     # 重複・スペース始まりコマンドを不記録
export PROMPT_COMMAND="history -a"          # 履歴の都度書き込み・読み込まない
shopt -s histappend                         # .bash_historyは追記する

# alias
alias ls='ls -FG --color=auto'
alias ll='ls -lhFG --color=auto'
alias la='ls -AFG'
alias l='ls -CFG'

# sshd
if ! pgrep -x "sshd" > /dev/null; then sshd; fi

