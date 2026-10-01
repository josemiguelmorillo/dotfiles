# dotfiles

Personal command-line configuration for macOS and Windows Subsystem for Linux.

## Install

Clone the repository and run the platform dispatcher:

```bash
git clone git@github.com:josemiguelmorillo/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./bootstrap.sh
```

`bootstrap.sh` calls `bootstrap-macos.sh` on macOS and `bootstrap-wsl.sh` on
WSL. Other Linux environments stop without making changes.

### macOS

The macOS installer uses Homebrew and `Brewfile`, installs Oh My Zsh, and
links the common and macOS packages with GNU Stow.

### WSL

The WSL installer:

- installs command-line dependencies with `apt`;
- installs Oh My Zsh, uv, and fnm when missing;
- preserves the current Git settings, including authentication, in `~/.gitconfig.local`;
- moves conflicting real files to `~/.dotfiles-backup/<timestamp>/`;
- links the common and WSL packages with GNU Stow.
- configures interactive Bash terminals to start Zsh while keeping Bash scripts unchanged.

Run only the linking and backup phase during development with:

```bash
DOTFILES_SKIP_INSTALL=1 ./bootstrap-wsl.sh
```

## Layout

```text
stow/
├── common/  # Vim, ctags, and Fabric patterns
├── macos/   # macOS Git, SSH, tmux, Zsh, Ghostty, and Kitty settings
└── wsl/     # WSL Git, tmux, and Zsh settings
```

Each child of these directories is a GNU Stow package. Managed files include
`.zshrc`, `.gitconfig`, `.gitignore`, `.tmux.conf`, `.vimrc`, `.ctags`, SSH and
Ghostty and Kitty configuration on macOS, and Fabric custom patterns.

## Machine-specific settings

WSL keeps existing Git settings in `~/.gitconfig.local`, which is included by
the managed `.gitconfig`. API keys and other secrets remain outside this
repository.

The macOS Git conditional includes expect client repositories below
`~/Projects/clients/`. Add the SSH keys referenced by the macOS SSH config
before using its host aliases.

## Shell helpers

- `t` starts or attaches to one tmux session for the current project.
- `ta` selects an existing tmux session with `fzf`.
- `tk` selects an existing tmux session with `fzf` and kills it.
- `tl` lists tmux sessions.

## Fabric patterns

- Custom patterns live in `stow/common/fabric/.config/fabric/custom-patterns/`, one
  directory per pattern with a `system.md` inside.
- The macOS `~/.zshrc` points Fabric at them with `CUSTOM_PATTERNS_DIRECTORY`, so
  `fabric --updatepatterns` refreshes only the upstream patterns in
  `~/.config/fabric/patterns` and never touches these.
- Fabric's `~/.config/fabric/.env` holds API keys and is deliberately not
  managed here; run `fabric --setup` once per machine.

Install optional macOS GUI apps separately: Ghostty, Kitty, Rancher Desktop,
and Google Chrome Dev. Bootstrap backs up existing Kitty configuration before
linking `~/.config/kitty/kitty.conf`.

## Additional managed configuration

- macOS: AeroSpace configuration and its window-management helper script, plus
  `~/.config/git/ignore`.
- Common: htop preferences and GitLab CLI aliases. GitLab credentials and
  recovery files remain local.
- The ctags package also links `~/.config/ctags/exclude.ctags`.
- All Fabric custom patterns, including `emoji_title`, live under
  `stow/common/fabric/`.

The macOS bootstrap repairs legacy symlinks into `.dotfiles`. Conflicting configuration
files are backed up under `~/.dotfiles-backup/` before Stow links them.
Use `DOTFILES_SKIP_INSTALL=1 ./bootstrap-macos.sh` to run only the linking phase.
Fish installer paths, Flutter signing settings, OpenCode generated files,
credentials, caches, and application state remain machine-specific.
