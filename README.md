# dotfiles

macOS development environment for a personal and a work Mac, managed with
[chezmoi](https://www.chezmoi.io/) in symlink mode.

## What's here

| Path | Contents |
|---|---|
| `home/` | chezmoi source state (selected by `.chezmoiroot`): zsh, git, tmux, Ghostty, starship, bat, mise, atuin, Hammerspoon (config only; not in the Brewfiles), vim |
| `nvim/` | Neovim config, linked as one directory to `~/.config/nvim` |
| `Brewfile`, `Brewfile.personal`, `Brewfile.work` | Homebrew packages, shared and per machine |

Config lives in XDG locations (`~/.config/zsh`, `~/.config/git`, `~/.config/tmux`, …).
`~/.zshenv` sets `ZDOTDIR`, the `XDG_*` variables, `LANG`, `EDITOR` and `VISUAL`. Runtimes
come from mise (Ruby, Java, Node, sbt) and uv (Python). The theme is gruvbox: Ghostty
switches between light and dark, tmux, fzf and starship follow it through the ANSI palette,
and bat has a light and a dark theme. delta stays on `gruvbox-dark`, and vim uses `retrobox`.

## Bootstrap a new Mac

1. Install [Homebrew](https://brew.sh), then put it on `PATH` for this shell:

   ```sh
   eval "$(/opt/homebrew/bin/brew shellenv)"
   ```

2. Install chezmoi:

   ```sh
   brew install chezmoi
   ```

3. Clone and apply. chezmoi asks for the machine (`personal` or `work`) and the git
   identity, then installs the Brewfiles and links everything:

   ```sh
   chezmoi init --apply --source ~/Development/personal/dotfiles https://github.com/pdcarv/dotfiles.git
   ```

4. **Work machines only:** machine-local settings live outside the repo. Shell settings
   go in `~/.config/zsh/work.zsh` (loaded if present); git settings go in
   `~/.config/git/config.local` (included if present).

## Daily workflow

- **Non-template files** (most of them) are symlinks into this repo. Edit them in place,
  e.g. `nvim ~/.config/zsh/.zshrc`, and the change is already in the repo.
- **Templates** (`*.tmpl`, e.g. `~/.config/git/config`) are rendered as real files.
  Edit the source with `chezmoi edit ~/.config/git/config` (or edit under `home/`), then
  `chezmoi apply`.
- **New files** under `$HOME` are not tracked until you run `chezmoi add <path>`. This
  includes new files under `~/.config/…`, except inside `~/.config/nvim`, which is the repo.
- **Brewfiles:** edit them and run `chezmoi apply`; a `run_onchange_` script installs
  whatever is missing (it never upgrades).
- Before applying anything unusual, check `chezmoi diff`.

## Machine data

`chezmoi init` asks once per machine and stores the answers only in the local
`~/.config/chezmoi/chezmoi.toml`:

| Key | Values | Used for |
|---|---|---|
| `machine` | `personal` \| `work` | Which `Brewfile.<machine>` applies, and whether `personal.zsh` is linked |
| `git_name`, `git_email` | identity | `[user]` in `~/.config/git/config` |
| `git_signingkey` | path to an SSH `.pub` key | commit signing |

To change an answer, edit `~/.config/chezmoi/chezmoi.toml` and run `chezmoi apply`.
Don't use `git config --global`: it writes to the rendered `~/.config/git/config`, and
the next apply reverts it. Change the template (`chezmoi edit ~/.config/git/config`) instead.
