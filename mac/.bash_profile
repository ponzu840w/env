# ~/.bash_profile @macbook

# 環境変数一般
export BASH_SILENCE_DEPRECATION_WARNING=1 # zshの売り込みを抑制
export MVK_CONFIG_LOG_LEVEL=1             # moltenvkのログ抑制
export DISPLAY=:0
export EDITOR=vim                         # COMMON SENSE
export WINEDEBUG=-all
export GST_PLUGIN_LOADING_WHITELIST="gstreamer:gst-plugins-base:gst-plugins-good"

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/Users/ponzu840w/.lmstudio/bin" # LM Studio

# 個別ソフト環境セットアップ
eval "$(/opt/homebrew/bin/brew shellenv)" # homebrew
. "$HOME/.cargo/env" # cargo

# ~/.bashrcの実行
if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

