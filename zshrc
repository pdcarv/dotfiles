setopt PROMPT_SUBST
autoload -U promptinit && promptinit
autoload -U compinit && compinit
autoload -U predict-on && predict-on

# load shell
source ~/.zsh/pure.zsh

export PATH=/usr/local/bin:${PATH}
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/bin"
export PATH="/usr/local/heroku/bin:$PATH"

export EDITOR=vi
set -o emacs

alias ls="ls -G"
alias ll="ls -lG"
alias gr=parent_dir_of_repo()
alias z="zeus $*"

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

function parent_dir_of_repo() {
 builtin cd $(git rev-parse --show-toplevel)
}

# Rbenv
export PATH="$PATH:$HOME/.rbenv/bin"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

