# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#Win10のX鯖につなぐ
#重さの原因？
#export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
#export DISPLAY=$(ip route list default | awk '{print $3}'):0
export DISPLAY=192.168.0.11:0

#My Aliases
#alias vim='vim.exe -c "colorscheme default" -c "set shell=bash"'

# パスのlinux->windows変換
#   新規ファイルなどの面倒に対応
#   vimのファイル名指定用
function __vimarg () {
  local EXEARG=$(echo $@ | awk 'BEGIN{ORS} {
    split($0,inarg)
    for(i in inarg){
      #print "[[DEBUG]inarg["i"]:"inarg[i]"]"
      if(inarg[i]~/^-/){ # オプション引数は素通り
        print(inarg[i])
      }else{             # パス引数
        "test -d "inarg[i]" ; echo $?" | getline ts
        if (ts==0) {     # ディレクトリなら、そのままWindowsパスにする
          print(winpath(inarg[i]))
        }else{           # ファイルの場合、新規ファイルかもしれないのでディレクトリ部分だけwslpathに通す。
          num=split(inarg[i],splpath,"/")
          if (num==1) {  # カレントディレクトリならそれも必要なし
            print(inarg[i])
          }else{
            base=substr(inarg[i],1,length(inarg[i])-length(splpath[num]))
            print("'\''"winpath(base) "\\" splpath[num]"'\''")
          }
        }
      }
    }
  }
  function winpath(path,  wpath) {  # UNIXパスがWindowsパスになって返る魔法の関数。
    #print "[[DEBUG]winpath:"path"]"
    "wslpath -w "path"" | getline wpath
    close("wslpath -w "path"")  #パイプ閉じ忘れがち
    return wpath
  }')
  #echo "[DEBUG] \$EXEARG=" $EXEARG
  echo $EXEARG
}
function vim () { # CoolRetroTerm用
  # シェルのカレントディレクトリに移動するvimスクリプトを作成
  # ***直接eval文中でやると二バイト文字が暴れる***
  echo 'cd '$(__vimarg .) > /tmp/vimopendir.vim
  # CRTのときはデフォルトカラースキームにする
  local VIMCOM='set shell=bash'
  # https://askubuntu.com/questions/210182/how-to-check-which-terminal-emulator-is-being-currently-used
  local TERMNAME=$(basename "/"$(ps -o cmd -f -p $(cat /proc/$(echo $$)/stat | cut -d \  -f 4) | tail -1 | sed 's/ .*$//'))
  if [[ "$TERMNAME" == Cool-Retro-Term* ]]; then
    VIMCOM="colorscheme default|$VIMCOM"
  fi
  # 1.作成したスクリプトの実行
  # 2.カラースキームを指定
  # 3.termコマンドで出るシェルをbashに変更
  # をしたうえで、（Windowsパスに変換された）引数ファイルを開く
  eval nvim.exe "-S" $(__vimarg /tmp/vimopendir.vim) "-c" '"$VIMCOM"' $(__vimarg $@)
}
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


#function hman () {
#  tmpfile=$(mktemp --suffix=.html)
#  man $@ | mandoc -Thtml > $tmpfile
#  wslpath -w $tmpfile | sed s/\\$/%24/ | sed 's/\\/\\\\/g' | xargs /mnt/c/"Program Files (x86)"/Microsoft/Edge/Application/msedge.exe
#}
alias cmd='cmd.exe /c'
alias diff='colordiff -uwB'
alias ii='pwsh.exe -Command ii'
alias gitlog='git log --decorate --oneline --graph'
alias type='cat'
alias fasm='fasm.exe'
#alias rustc='rustc.exe'
#alias cargo='cargo.exe'
#alias pwsh='pwsh.exe -Command'
function pwsh () {
  if [ $# -eq 0 ];then
    pwsh.exe
  else
    pwsh.exe -Command $@
  fi
}
export QT_SCALE_FACTOR=1
export GDK_SCALE=1

alias nik='vim ~/wh/OneDrive/doc/nikki'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
export PATH="$PATH:/mnt/c/Program Files/Oracle/VirtualBox"
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH="/mnt/c/HashiCorp/"
#export VAGRANT_HOME="/mnt/c/Users/ポン酢/.vagrant.d"
export VAGRANT_HOME="~/.vagrant.d"
set -o vi

function share_history {
    history -a
    history -c
    history -r
}
PROMPT_COMMAND='share_history'
shopt -u histappend

#
# (c) 2021-2022 Harald Pretl
# Institute for Integrated Circuits
# Johannes Kepler University Linz
#
export PDK_ROOT=/home/ponzu840w/pdk
export PDK=gf180mcuD
export STD_CELL_LIBRARY=gf180mcu_fd_sc_mcu7t5v0

# ruby setup https://qiita.com/kerupani129/items/77dd1e3390b53f4e97b2
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
export GRDIR="$HOME/work/gr"

alias msbuild='msbuild.exe'
export PICO_SDK_PATH=$HOME/work/pico/pico-sdk
export PATH="/home/ponzu840w/work:$PATH"

export PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"
export MANPATH="$MANPATH:/usr/local/texlive/2025/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2025/texmf-dist/doc/info"
