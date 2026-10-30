# Sourced from the plugin bundle: after zsh-completions joins fpath, before fzf-tab.
# A full compinit (new functions, compaudit) runs at most once a day; otherwise
# the dump is trusted as-is.
autoload -Uz compinit
() {
    local dump=$XDG_CACHE_HOME/zsh/zcompdump
    [[ -d ${dump:h} ]] || mkdir -p ${dump:h}
    if [[ -n $dump(#qN.mh-24) ]]; then
        compinit -C -d $dump
    else
        compinit -d $dump
        touch $dump
    fi
}
