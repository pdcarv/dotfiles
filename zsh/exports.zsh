# Setting ag as the default source for fzf
export FZF_DEFAULT_COMMAND='ag -g ""'

# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# PATHS
export ZSH=$HOME/.zsh
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
export PATH=$PATH:$HOME/scripts
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/.rbenv/bin
export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${JAVA_HOME}/bin:$PATH
