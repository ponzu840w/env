# ~/.bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# VIPからきますた
function vip () {
echo '                          "";;";;     ザッザッザ・・・
                            """;;";";;    ザッザッザ・・・
                             """;;";"";";
                                ;;";";"";";"
                                  ;;"";";;"";;";
            VIPからきますた        vymyvwymyvymyvy、
                                  MVvvMvyvMVvvMvyvMVvv、
                              ﾍ＿＿Λ ﾍ＿＿Λ ﾍ＿＿Λ ﾍ＿＿Λ
        VIPかららきすた      Λ＿ﾍ＾－＾Λ＿ﾍ＾－＾Λ＿ﾍ＾Λ＿ﾍ   VIPから
                 ＿＿,.ヘ /ヽ＿ /ヽ＿＿,.ヘ /ヽ＿＿,.ヘ ＿,.ヘ  きますた
         /＼＿＿_／ヽ   /＼＿＿＿ /＼＿＿_／ヽ _／ヽ /＼＿＿_／ヽ
       ／"""   """:::＼／"""   "／"""   """:::＼   ／"""   """:::＼
    . | (●),    ､(●)､.:|(●),   | (●),    ､(●)､.:|`| (●),    ､(●)､.:|
     |   ,,ﾉ(､_, )ヽ､,,| ,,ﾉ(､_|  ,,ﾉ(､_, )ヽ､,,|)|  ,,ﾉ(､_, )ヽ､,,|
  .   |   ｀-=ﾆ=-   ".:|  ｀-=ﾆ|   ｀-=ﾆ=-   ".:|ﾆ|   ｀-=ﾆ=-   ".:|
       ＼  ｀ﾆﾆ´   .:／ ＼｀ﾆﾆ´ ＼  ｀ﾆﾆ´   .:／ﾆ" ＼  ｀ﾆﾆ´   .:／
       ／｀ー‐--‐‐―´＼  ／      ／｀ー‐--‐‐―´＼ --‐／｀ー‐--‐‐―´＼'
}

# history
export HISTSIZE=5000
export HISTFILESIZE=5000000000000000        # 履歴5000兆件欲しい！
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S "  # historyで日付見れる
export HISTCONTROL=ignoreboth:erasedups     # 重複・スペース始まりコマンドを不記録
export PROMPT_COMMAND="history -a"          # 履歴の都度書き込み・読み込まない
shopt -s histappend                         # .bash_historyは追記する

# 非テキストファイルを前処理してlessで見やすくするlesspipeの有効化
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# debian_chrootの設定 chroot環境でプロンプトに表示するためのもの
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# 色表示に対応したターミナルの場合、プロンプトを色付きにする
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# プロンプトの設定
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\n\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\n\$ '
fi
unset color_prompt force_color_prompt

# xterm系ターミナルの場合、ウィンドウタイトルを設定
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# GCCの色付き出力設定
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# コマンドラインタブ補完
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Win10のX鯖につなぐ
#export DISPLAY=192.168.0.11:0
export DISPLAY=$(ip route list default | awk '{print $3}'):0

# hmanコマンドをWindowsのEdgeで開く
function hman () {
  tmpfile=$(mktemp --suffix=.html)
  man $@ | mandoc -Thtml > $tmpfile
  wslpath -w $tmpfile | sed s/\\$/%24/ | sed 's/\\/\\\\/g' | xargs /mnt/c/"Program Files (x86)"/Microsoft/Edge/Application/msedge.exe
}

# viモードを有効化
set -o vi

# .bash_aliasesがあれば読み込む
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ~/.bashrc.d 以下のスクリプトをすべて読み込む
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

