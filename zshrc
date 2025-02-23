# Performance optimization - compile if needed
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi
FUNCNEST=1000

# Path to zsh configuration directory
export ZSH=$HOME/.zsh

# Load antidote (modern antibody replacement)
source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

# Vi mode configuration
bindkey -v  # Enable vi mode
export KEYTIMEOUT=1  # Reduce mode switch delay

# Enable editing in EDITOR for long commands
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line  # Use Ctrl-X-E instead of just Ctrl-E
bindkey -M vicmd 'v' edit-command-line  # Bind 'v' in normal mode to edit

# Better vi mode bindings
bindkey -M viins '^n' down-line-or-history
bindkey -M viins '^p' up-line-or-history
bindkey -M viins '^k' up-line-or-search
bindkey -M viins '^j' down-line-or-search
bindkey -M viins '^e' end-of-line
bindkey -M viins '^f' forward-char
bindkey -M viins '^b' backward-char
bindkey -M isearch '^e' accept-search

# Load all configuration files dynamically
for conf in "$ZSH"/*.zsh; do
    [[ -f "$conf" ]] && source "$conf"
done

# Modern development tools initialization
# Only initialize if commands exist
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi

if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    alias zi='z -i'    # Interactive selection
    alias za='zoxide add'  # Manually add a directory
fi

if (( $+commands[atuin] )); then
    export ATUIN_NOBIND="true"  # Prevent atuin from binding its own keys
    eval "$(atuin init zsh)"
    bindkey '^r' _atuin_search_widget  # Bind Ctrl-R explicitly
fi

# FZF Configuration
if [[ -f ~/.fzf.zsh ]]; then
    source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    bindkey '^[c' fzf-cd-widget
    bindkey '^T' fzf-file-widget
fi

# Modern CLI tool alternatives
if (( $+commands[exa] )); then
    alias ls='exa --icons --git'
    alias ll='exa -l --icons --git'
    alias la='exa -la --icons --git'
    alias tree='exa --tree'
fi

if (( $+commands[bat] )); then
    alias cat='bat'
fi

if (( $+commands[fd] )); then
    alias find='fd'
fi

if (( $+commands[ripgrep] )); then
    alias grep='rg'
fi

# Node version management
if (( $+commands[fnm] )); then
    eval "$(fnm env --use-on-cd)"
fi

# Python environment management
if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
fi

# Improved command history
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.

# Directory stack
setopt AUTO_PUSHD               # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS        # Do not store duplicates in the stack.
setopt PUSHD_SILENT            # Do not print the directory stack after pushd or popd.

# Completion system
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Load any local machine specific configurations
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
