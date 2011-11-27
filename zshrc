# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
export ZSH_THEME="kphoen"

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# export DISABLE_AUTO_TITLE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rvm textmate ruby rails)

source $ZSH/oh-my-zsh.sh

alias pg_start="pg_ctl -D /usr/local/var/postgres -l logfile start"
alias be="bundle exec"

declare -x JDK_HOME="/System/Library/Java/JavaVirtualMachines/1.6.0.jdk/Contents"

# Customize to your needs...
export PATH=/Users/Pedro/scripts:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/mongodb/bin:/usr/texbin:/usr/X11/bin
# For rbenv 
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Clojure
export CLASSPATH=$CLASSPATH:/usr/local/Cellar/clojure/1.3.0/clojure-1.3.0.jar
export CLASSPATH=$CLASSPATH:/usr/local/Cellar/clojure-contrib/1.2.0/clojure-contrib.jar
