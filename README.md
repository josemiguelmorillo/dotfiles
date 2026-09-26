# dotfiles

Personal command-line configuration for macOS and Windows Subsystem for Linux.

## Install

Clone the repository and run the platform dispatcher:

```bash
git clone https://github.com/josemiguelmorillo/dotfiles.git ~/.dotfiles
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

Run only the linking and backup phase during development with:

```bash
DOTFILES_SKIP_INSTALL=1 ./bootstrap-wsl.sh
```

## Layout

```text
stow/
├── common/  # Vim, ctags, and Fabric patterns
├── macos/   # macOS Git, SSH, tmux, Zsh, and Ghostty settings
└── wsl/     # WSL Git, tmux, and Zsh settings
```

Each child of these directories is a GNU Stow package. Managed files include
`.zshrc`, `.gitconfig`, `.gitignore`, `.tmux.conf`, `.vimrc`, `.ctags`, SSH and
Ghostty configuration on macOS, and Fabric custom patterns.

## Machine-specific settings

WSL keeps existing Git settings in `~/.gitconfig.local`, which is included by
the managed `.gitconfig`. API keys and other secrets remain outside this
repository.

The macOS Git conditional includes expect client repositories below
`~/Projects/clients/`. Add the SSH keys referenced by the macOS SSH config
before using its host aliases.
