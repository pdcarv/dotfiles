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

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
