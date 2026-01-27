# ~/.bash_profile @termux

# 環境変数
export EDITOR=vim                         # COMMON SENSE

# PATH
export PATH="$HOME/.local/bin:$PATH"

# ~/.bashrcの実行
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

