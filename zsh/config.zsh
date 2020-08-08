autoload -U promptinit && promptinit
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi

export EDITOR=vim
set -o emacs

setopt autocd
setopt extendedglob
setopt correct correct_all
setopt prompt_subst
unsetopt flow_control

autoload -U edit-command-line

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
