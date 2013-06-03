autoload -U colors && colors
autoload -Uz vcs_info
autoload compinit && compinit

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:git*' stagedstr "%F{28}●"
zstyle ':vcs_info:git*' unstagedstr "%F{11}●"
zstyle ':vcs_info:git*' formats "in %{$fg_bold[cyan]%}%b %{$reset_color%}%m%u%c%{$reset_color%} "
zstyle ':vcs_info:git*' check-for-changes true
zstyle ':vcs_info:git*' get-revision true

# Tab completion
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache 
zstyle ':completion:*' special-dirs true

# I want emacs style file searching
bindkey "^R" history-incremental-search-backward
bindkey "^[[3~" delete-char

precmd () { vcs_info }
setopt prompt_subst

PROMPT='%{$fg[cyan]%}%1~%{$reset_color%}%{$fg[red]%}|%{$reset_color%}${vcs_info_msg_0_}%{$fg[cyan]%}>%{$reset_color%} '

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.rbenv/bin"
export PATH="$PATH:/usr/local/mongodb/bin" 
export PATH="$PATH:/usr/local/share/npm/bin"
export PATH="$PATH:/usr/local/go/bin"
export EDITOR="vim"

# Aliases
alias ls='ls -G'
alias git-root='cd $(git rev-parse --show-toplevel)'

# Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

# Rbenv
eval "$(rbenv init -)"
