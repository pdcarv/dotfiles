setopt PROMPT_SUBST
autoload -U promptinit && promptinit
autoload -U compinit && compinit

export EDITOR=vim
set -o emacs

setopt autocd
setopt extendedglob
setopt correct correct_all
setopt prompt_subst
unsetopt flow_control

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

export ZSH=$HOME/.zsh

# install with brew install zsh-completions
fpath=(/usr/local/share/zsh-completions/ $fpath)

# load shell config
source $ZSH/prompts/pure.zsh
source $ZSH/aliases.zsh
source $ZSH/completion.zsh
source $ZSH/history.zsh
source $ZSH/functions.zsh

export GOPATH=$HOME/code/go
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$HOME/bin
export PATH=/usr/local/heroku/bin:$PATH
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.rbenv/bin
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules

stty ixany
stty ixoff -ixon

# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $ZSH/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
