# ~/.bash_profile

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# 日本語入力 Fcitx設定
# https://astherier.com/blog/2020/08/install-fcitx-mozc-on-wsl2-ubuntu2004/
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export DefaultIMModule=fcitx
if [ $SHLVL = 1 ] ; then
  (fcitx-autostart > /dev/null 2>&1 &)
  xset -r 49  > /dev/null 2>&1
fi
export QT_SCALE_FACTOR=1
export GDK_SCALE=1

# IIC-OSIC-TOOLS
# (c) 2021-2022 Harald Pretl
# Institute for Integrated Circuits
# Johannes Kepler University Linz
#
export PDK_ROOT=/home/ponzu840w/pdk
export PDK=gf180mcuD
export STD_CELL_LIBRARY=gf180mcu_fd_sc_mcu7t5v0

# Ruby
eval "$($HOME/.rbenv/bin/rbenv init - bash)"
export GRDIR="$HOME/work/gr"

# Raspberry Pi Pico SDK
export PICO_SDK_PATH=$HOME/work/pico/pico-sdk

# TeX Live 2025
export PATH="$PATH:/usr/local/texlive/2025/bin/x86_64-linux"
export MANPATH="$MANPATH:/usr/local/texlive/2025/texmf-dist/doc/man"
export INFOPATH="$INFOPATH:/usr/local/texlive/2025/texmf-dist/doc/info"

# Rust
. "$HOME/.cargo/env"

# Perl plenv
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# chdzimg
export PATH="$PATH:~/work/chdzimg/bin"

