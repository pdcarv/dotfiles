# Load local config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Performance optimization - zshrc compilation
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi

# Increase function nesting limit to prevent errors with Starship
FUNCNEST=2000

# Path to zsh configuration directory
export ZSH=$HOME/.zsh

# Improved command history - set early
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Directory stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

autoload -Uz compinit
# Check if cache exists and use it
if [ -f "${ZDOTDIR:-$HOME}/.zcompdump" ]; then
  # Use cached completion data instead of rebuilding
  compinit -C
else
  compinit
fi

# Compile completion cache to speed up loading
if [[ -f "${ZDOTDIR:-$HOME}/.zcompdump" && (! -f "${ZDOTDIR:-$HOME}/.zcompdump.zwc" || "${ZDOTDIR:-$HOME}/.zcompdump" -nt "${ZDOTDIR:-$HOME}/.zcompdump.zwc") ]]; then
  zcompile "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# Define minimal completion styles immediately, delay loading the more complex ones
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Load antidote - plugin manager
source ${ZDOTDIR:-~}/.antidote/antidote.zsh

# Create/load static plugin file with minimal plugins
ANTIDOTE_STATIC_FILE=${ZDOTDIR:-~}/.zsh_plugins.zsh
if [[ ! -f $ANTIDOTE_STATIC_FILE || ${ZDOTDIR:-~}/.zsh_plugins.txt -nt $ANTIDOTE_STATIC_FILE ]]; then
  [[ -f ${ZDOTDIR:-~}/.zsh_plugins.txt ]] || {
    # If plugins file doesn't exist, create one with essential plugins
    cat > ${ZDOTDIR:-~}/.zsh_plugins.txt <<EOF
# IMPORTANT: Only load these two plugins
zsh-users/zsh-autosuggestions
zsh-users/zsh-syntax-highlighting
EOF
  }
  antidote bundle < ${ZDOTDIR:-~}/.zsh_plugins.txt > $ANTIDOTE_STATIC_FILE
fi
source $ANTIDOTE_STATIC_FILE

# ULTRA-MINIMAL zsh-autosuggestions plugin config
# Maximum performance settings
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=5
export ZSH_AUTOSUGGEST_USE_ASYNC=true
export ZSH_AUTOSUGGEST_MANUAL_REBIND=true
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *|ls *|git *"

# ULTRA-MINIMAL zsh-syntax-highlighting config
# Minimal settings for maximum performance
export ZSH_HIGHLIGHT_MAXLENGTH=50
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=''
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'

# Vi mode configuration - ultra minimal
bindkey -v
export KEYTIMEOUT=1

# Essential keybindings only - keep to absolute minimum
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Add vi-mode specific history search bindings
bindkey -M viins '^k' up-line-or-search     # Search history up with Ctrl+K
bindkey -M viins '^j' down-line-or-search   # Search history down with Ctrl+J
bindkey -M isearch '^e' accept-search       # Accept search with Ctrl+E during search

# Lazy-load all completion on first tab press
function load-completion-system() {
  # Remove this function after it's run once
  unfunction load-completion-system
  
  # Load more completion settings only when needed
  zstyle ':completion:*' use-cache on
  zstyle ':completion:*' cache-path ~/.zsh/cache
  zstyle ':completion:*' verbose yes
  
  # Return true
  return 0
}

# Override tab completion to lazy-load completion system
function complete-with-dots() {
  # Load completion system if not loaded
  load-completion-system 2>/dev/null
  
  # Display dots while completing
  echo -n "\e[31m...\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N complete-with-dots
bindkey "^I" complete-with-dots

# Modern CLI tool alternatives - with better command detection
if (( $+commands[exa] )); then
    alias ls='exa'
    alias ll='exa -l'
    alias la='exa -la'
fi

if (( $+commands[bat] )); then
    alias cat='bat'
fi

if (( $+commands[fd] )); then
    alias find='fd'
fi

if (( $+commands[rg] )); then
    # If the command is available as 'rg'
    alias grep='rg'
elif (( $+commands[ripgrep] )); then
    # If it's available as 'ripgrep'
    alias grep='ripgrep'
fi

# Only load when explicitly called

# Ruby environment
rbenv() {
  # Remove this function
  unfunction rbenv
  # Load the real rbenv
  eval "$(command rbenv init -)"
  # Call the now-loaded command
  rbenv "$@"
}

# Directory navigation
zoxide() {
  unfunction zoxide
  eval "$(command zoxide init zsh)"
  alias zi='z -i'
  alias za='zoxide add'
  zoxide "$@"
}

# Node version management with Vim/coc.nvim support
fnm() {
  unfunction fnm
  # Load fnm properly
  eval "$(command fnm env --use-on-cd)"
  fnm "$@"
}

# Ensure node is available for Vim/Neovim with coc.nvim
vim() {
  # If node is not in path and fnm exists
  if ! command -v node >/dev/null 2>&1 && command -v fnm >/dev/null 2>&1; then
    # Load fnm first
    eval "$(command fnm env --use-on-cd)"
  fi
  # Then run the real vim command
  command vim "$@"
}

# Also handle neovim if you use it
nvim() {
  # If node is not in path and fnm exists
  if ! command -v node >/dev/null 2>&1 && command -v fnm >/dev/null 2>&1; then
    # Load fnm first
    eval "$(command fnm env --use-on-cd)"
  fi
  # Then run the real nvim command
  command nvim "$@"
}

# Python environment
pyenv() {
  unfunction pyenv
  eval "$(command pyenv init -)"
  pyenv "$@"
}

# Atuin - improved widget detection and fallback chain
if (( $+commands[atuin] )); then
    # Tell Atuin not to set up its own keybindings
    export ATUIN_NOBIND="true"
    
    # Initialize Atuin directly (not lazy-loaded)
    eval "$(atuin init zsh --disable-up-arrow)"
    
    # Get the actual Atuin widget name (more robust)
    local atuin_widget_name
    for widget in ${(k)widgets}; do
        if [[ $widget == *atuin*search* ]]; then
            atuin_widget_name=$widget
            break
        fi
    done
    
    # Bind Ctrl+R to Atuin's search widget if found
    if [[ -n "$atuin_widget_name" ]]; then
        bindkey '^r' $atuin_widget_name
    else
        # Fallback in case widget not found
        bindkey '^r' history-incremental-search-backward
    fi
else
    # FZF history search if Atuin isn't available
    if [[ -f ~/.fzf.zsh ]]; then
        bindkey '^r' _fzf_history_wrapper
    else
        # Traditional history search as last resort
        bindkey '^r' history-incremental-search-backward
    fi
fi

# FZF Configuration - with context-specific settings
_fzf_init_and_run() {
    # Which widget should we run after init
    local widget_to_run="$1"
    
    # Initialize FZF if not already done
    if [[ -f ~/.fzf.zsh ]] && [[ -z "$FZF_INITIALIZED" ]]; then
        export FZF_INITIALIZED=1
        
        # Common options without preview (simpler, works everywhere)
        export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
        
        # File-specific settings
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        
        # Only use preview for file operations if bat exists
        if (( $+commands[bat] )); then
            # Context-specific options
            export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
        fi
        
        # History-specific settings - no preview, optimized for commands
        export FZF_CTRL_R_OPTS="--no-preview"
        
        # Source FZF but don't disable its keybindings (to match original)
        source ~/.fzf.zsh
    fi
    
    # If widget exists now, run it
    if [[ "$widget_to_run" == "file" ]]; then
        zle fzf-file-widget
    elif [[ "$widget_to_run" == "cd" ]]; then
        zle fzf-cd-widget
    elif [[ "$widget_to_run" == "history" ]]; then
        zle fzf-history-widget
    fi
}

# Create wrapper widgets for FZF functions
_fzf_file_wrapper() { _fzf_init_and_run "file"; }
_fzf_cd_wrapper() { _fzf_init_and_run "cd"; }
_fzf_history_wrapper() { _fzf_init_and_run "history"; }

# Define these as ZLE widgets
zle -N _fzf_file_wrapper
zle -N _fzf_cd_wrapper
zle -N _fzf_history_wrapper

# Bind keys to our wrapper functions - matches original config
bindkey '^T' _fzf_file_wrapper
bindkey '^[c' _fzf_cd_wrapper

# Load configuration files from ~/.zsh/ directory
if [[ -d "$ZSH" ]]; then
  # Define priority files to load first (if they exist)
  priority_files=(
    "$ZSH/aliases.zsh"     # Common to have aliases first
    "$ZSH/functions.zsh"   # Functions often needed early
    "$ZSH/env.zsh"         # Environment variables
    "$ZSH/path.zsh"        # PATH modifications
  )
  
  # Load priority files first
  for conf in "${priority_files[@]}"; do
    [[ -f "$conf" ]] && source "$conf"
  done
  
  # Then load all other .zsh files
  for conf in "$ZSH"/*.zsh; do
    # Skip already loaded priority files
    if [[ -f "$conf" ]] && ! printf '%s\n' "${priority_files[@]}" | grep -q "^$conf$"; then
      source "$conf"
    fi
  done
fi

# Initialize Starship prompt with multiple detection methods
# First, check if we've already confirmed Starship is installed in a previous session
if command -v starship >/dev/null 2>&1 || [[ -x /usr/local/bin/starship ]] || [[ -x /opt/homebrew/bin/starship ]]; then
  # Cache for better performance
  export STARSHIP_CACHE=~/.cache/starship
  mkdir -p $STARSHIP_CACHE
  
  # Initialize with caching enabled
  eval "$(starship init zsh)"
else
  # Super minimal fallback prompt - maximum performance
  PS1='%F{cyan}%~%f %F{green}❯%f '
  
  # Only show message on first run
  if [[ -z "$STARSHIP_NOTIFIED" ]]; then
    export STARSHIP_NOTIFIED=1
    echo "Starship prompt not installed. Run: brew install starship"
    echo "If Starship is already installed but not being detected, run: touch ~/.starship_installed"
  fi
fi
