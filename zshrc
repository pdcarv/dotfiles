# AUTHOR:
#   Pedro Carvalho
#
autoload -U colors && colors
autoload -Uz vcs_info
autoload compinit && compinit

zstyle ':vcs_info:*' enable git hg svn
zstyle ':vcs_info:git*' formats "in %{$fg_bold[cyan]%}%b %{$reset_color%}"
zstyle ':vcs_info:*' check-for-changes true

precmd () { vcs_info }
setopt prompt_subst


PROMPT='
%{$fg_bold[magenta]%}%~%{$reset_color%} ${vcs_info_msg_0_}
> '

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin
export PATH="$PATH:$HOME/scripts"
export PATH="$PATH:/usr/local/mongodb/bin" 
export EDITOR="vim"

# Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

# Rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
