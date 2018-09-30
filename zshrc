# Antibody (Prompt and Plugins)
source ~/.zsh_plugins.sh

# Load all configuration files
source $ZSH/exports.zsh
source $ZSH/config.zsh
source $ZSH/aliases.zsh
source $ZSH/helpers.zsh

# Rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


