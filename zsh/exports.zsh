# Define paths in a more organized way to avoid duplication and potential path issues
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

# Node.js
export NODE_PATH="/usr/local/lib/node_modules"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Editor
export EDITOR='vim'
export VISUAL='vim'

# Less
export LESS='-R --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# History
export HISTSIZE=1000000
export SAVEHIST=1000000
export HISTFILE="$HOME/.zsh_history"
export HIST_STAMPS="yyyy-mm-dd"

# Language/Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# FZF
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Development
export PYTHONDONTWRITEBYTECODE=1  # Prevent Python from writing .pyc files
export VIRTUAL_ENV_DISABLE_PROMPT=1  # Let our own prompt handle venv status

# Fix for GPG
export GPG_TTY=$(tty)

# Docker
export DOCKER_BUILDKIT=1  # Enable BuildKit for better Docker build performance

# Go
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

