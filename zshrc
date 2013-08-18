autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U colors && colors
autoload -Uz vcs_info

# Tab completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache 
zstyle ':completion:*' special-dirs true

# Emacs style file searching
bindkey "^R" history-incremental-search-backward
bindkey "^[[3~" delete-char
export EDITOR="vim"

setopt prompt_subst
setopt correctall
setopt auto_menu

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:*:*' stagedstr "%F{28}✚"
zstyle ':vcs_info:*:*' unstagedstr "%F{11}●"
zstyle ':vcs_info:*:*' check-for-changes true
zstyle ':vcs_info:*:*' get-revision true
zstyle ':vcs_info:*:*' formats "%m%u%c %b" 

precmd () { vcs_info }

PROMPT='%% %{$reset_color%}'
RPROMPT='%{$fg[cyan]%}%~%{$reset_color%} ${vcs_info_msg_0_}%{$reset_color%}'

export PATH=/usr/local/bin:${PATH}
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/bin"

export ACK_COLOR_MATCH='magenta'

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.history"
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt share_history
setopt append_history

setopt autocd
setopt extendedglob

# Aliases
alias ls="ls -G"
alias git-root="cd $(git rev-parse --show-toplevel)"
alias z="zeus $*"

# Rbenv
export PATH="$PATH:$HOME/.rbenv/bin"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi


if [[ -x "$(which keychain)" ]]; then
    eval "$(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_dsa)"
fi
