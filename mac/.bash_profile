export BASH_SILENCE_DEPRECATION_WARNING=1
export DISPLAY=:0
export EDITOR=vim # COMMON SENSE

eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.bashrc ]; then . ~/.bashrc; fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/ponzu840w/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.local/bin:$PATH"

export MVK_CONFIG_LOG_LEVEL=1
