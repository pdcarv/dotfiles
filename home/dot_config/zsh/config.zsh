autoload -U promptinit && promptinit

setopt autocd
setopt extendedglob
setopt correct
setopt prompt_subst
unsetopt flow_control

autoload -U edit-command-line

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
