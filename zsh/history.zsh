if [ -z $HISTFILE ]; then
  export HISTFILE="$HOME/.history"
fi

export HISTSIZE=10000
export SAVEHIST=10000

setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt share_history
setopt append_history
