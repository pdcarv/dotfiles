function gr() {
 builtin cd $(git rev-parse --show-toplevel)
}

function lag() {
  ag --group --color $* | less -r +k
}

# fv - open selected file with default editor
fv() {
  local files

  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})

  if [[ -n $files ]]
  then
    vim -- $files
    print -l $files[1]
  fi
}

# fcd - cd to selected directory (uses the fd binary + fzf)
fcd() {
  local dir
  dir=$(fd --type d . "${1:-.}" 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# tm - fuzzy-pick a project dir under ~/Development, jump to (or create) its tmux session
tm() {
  local selected
  if [[ $# -eq 1 ]]; then
    selected=$1
  else
    selected=$(fd --type d --min-depth 2 --max-depth 2 . "$HOME/Development" 2>/dev/null | fzf)
  fi

  [[ -z $selected ]] && return 0

  local selected_name
  selected_name=$(basename "$selected" | tr . _)

  if [[ -z $TMUX ]] && [[ -z $(pgrep tmux) ]]; then
    tmux new-session -s "$selected_name" -c "$selected"
    return 0
  fi

  if ! tmux has-session -t="$selected_name" 2>/dev/null; then
    tmux new-session -ds "$selected_name" -c "$selected"
  fi

  if [[ -z $TMUX ]]; then
    tmux attach -t "$selected_name"
  else
    tmux switch-client -t "$selected_name"
  fi
}

# Clean all unused docker images
dcleanup() {
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}
