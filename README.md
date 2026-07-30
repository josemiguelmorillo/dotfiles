# dotfiles

Bootstrap this repo on a new Mac with:

```bash
git clone git@github.com:<your-user>/<your-dotfiles-repo>.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

What `bootstrap.sh` does:

- installs Homebrew if needed
- installs the command-line packages declared in `Brewfile`
- installs Oh My Zsh if it is missing
- stows the managed dotfiles from `stow/` into `$HOME`

Managed files:

- `~/.zshrc`
- `~/.gitconfig`
- `~/.gitconfig-tifin`
- `~/.gitconfig-criterian`
- `~/.gitignore`
- `~/.ssh/config`
- `~/.tmux.conf`
- `~/.vimrc`
- `~/.ctags`
- `~/.config/ghostty/config`
- `~/.config/fabric/custom-patterns/`

Shell helpers:

- `t` starts or attaches to one tmux session for the current project.
- `ta` selects an existing tmux session with `fzf`.
- `tk` selects an existing tmux session with `fzf` and kills it.
- `tl` lists tmux sessions.

Fabric patterns:

- Custom patterns live in `stow/fabric/.config/fabric/custom-patterns/`, one
  directory per pattern with a `system.md` inside.
- `~/.zshrc` points Fabric at them with `CUSTOM_PATTERNS_DIRECTORY`, so
  `fabric --updatepatterns` refreshes only the upstream patterns in
  `~/.config/fabric/patterns` and never touches these.
- Fabric's `~/.config/fabric/.env` holds API keys and is deliberately not
  managed here; run `fabric --setup` once per machine.

Notes for a new machine:

- Add the SSH keys referenced by `~/.ssh/config` before using the Git host aliases.
- Install optional GUI apps separately if you use them: Ghostty, Rancher Desktop, and Google Chrome Dev.
- The Git conditional includes assume your client repos live under `~/Projects/clients/...`.
