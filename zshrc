setopt PROMPT_SUBST
autoload -U promptinit && promptinit
autoload -U compinit && compinit

# load shell
source ~/.zsh/pure.zsh

# Completion stuff
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

export PATH=/usr/local/bin:/usr/local/sbin/:${PATH}
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/bin"
export PATH="/usr/local/heroku/bin:$PATH"

export EDITOR=vim
set -o emacs

alias ls="ls -G"
alias ll="ls -lG"
alias z="zeus $*"

function gr() {
 builtin cd $(git rev-parse --show-toplevel) 
}

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.history"
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history
setopt append_history

export ACK_COLOR_MATCH='magenta'

setopt autocd
setopt extendedglob
unsetopt flow_control

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^Xe' edit-command-line

stty ixany
stty ixoff -ixon

export SHELL="/usr/local/bin/zsh"
# Rbenv
export PATH="$PATH:$HOME/.rbenv/bin"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi



