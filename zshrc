# Antibody (Prompt and Plugins)
source ~/.zsh_plugins.sh


# Load all configuration files
export ZSH=$HOME/.zsh
source $ZSH/exports.zsh
source $ZSH/config.zsh
source $ZSH/aliases.zsh
source $ZSH/helpers.zsh

# Rbenv
rbenv() {
  eval "$(command rbenv init -)"
  rbenv "$@"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


