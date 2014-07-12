setopt PROMPT_SUBST
autoload -U promptinit && promptinit
autoload -U compinit && compinit

export ZSH=$HOME/.zsh

# install with brew install zsh-completions
fpath=(/usr/local/share/zsh-completions/ $ZSH/functions $fpath)

# load shell config
source $ZSH/prompts/pure.zsh
source $ZSH/aliases.zsh
source $ZSH/completion.zsh
source $ZSH/history.zsh

export GOPATH=$HOME/code/go
export PATH=/usr/local/bin:/usr/local/sbin:${PATH}
export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$HOME/bin
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.rbenv/bin
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

export EDITOR=vim
set -o emacs

export ACK_COLOR_MATCH='magenta'

setopt autocd
setopt extendedglob
unsetopt flow_control
setopt correct correct_all
setopt prompt_subst

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# command-t like functionality in terminal with selecta
bindkey -s "^P" " vim \$\(ag --nogroup --nocolor --column -l . 2>/dev/null | selecta\)\n"

stty ixany
stty ixoff -ixon

# Rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
