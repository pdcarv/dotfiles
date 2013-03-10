# AUTHOR:
#   Pedro Carvalho
#
#
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
zstyle ':completion:*' special-dirs true

# I want emacs style file searching
bindkey "^R" history-incremental-search-backward
bindkey "^[[3~" delete-char


precmd () { vcs_info }
setopt prompt_subst


PROMPT='
%{$fg_bold[magenta]%}%~%{$reset_color%} ${vcs_info_msg_0_}
> '

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.rbenv/bin"
export PATH="$PATH:/usr/local/mongodb/bin" 
export EDITOR="vim"

# Aliases
alias ls='ls -G'

# Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

# Rbenv
eval "$(rbenv init -)"
