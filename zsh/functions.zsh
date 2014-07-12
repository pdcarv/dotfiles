function gr() {
 builtin cd $(git rev-parse --show-toplevel)
}

function lag() {
  ag --group --color $* | less -r +k
}
