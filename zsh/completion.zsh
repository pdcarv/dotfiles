unsetopt menu_complete
setopt auto_menu
setopt complete_in_word
setopt always_to_end

zstyle ':completion:*' use-cache on
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
