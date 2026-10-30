function gr() {
 builtin cd $(git rev-parse --show-toplevel)
}

# fv - fuzzy-pick files under a directory (default .) and open them in $EDITOR
fv() {
  local -a files
  files=(${(f)"$(fd --type f --hidden --exclude .git . "${1:-.}" | fzf -m -0 -1 --preview 'bat --style=numbers --color=always {}')"})
  (( $#files )) && $EDITOR -- $files
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

# Remove stopped containers, dangling images, unused networks and build cache
dcleanup() {
  docker system prune "$@"
}
