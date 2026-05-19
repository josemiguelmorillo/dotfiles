#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
STOW_DIR="$DOTFILES_DIR/stow"
PACKAGES=(ctags ghostty git ssh vim zsh)

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew bundle --file="$BREWFILE"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

mkdir -p "$HOME/.config/ghostty" "$HOME/.nvm" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

stow --dir="$STOW_DIR" --target="$HOME" --restow "${PACKAGES[@]}"

chmod 600 "$HOME/.ssh/config"

cat <<EOF
Bootstrap complete.

Next steps:
  1. Add your SSH keys to ~/.ssh so the entries in ~/.ssh/config can resolve.
  2. Install optional GUI apps you use manually (Ghostty, Rancher Desktop, Google Chrome Dev).
  3. Restart your shell with: exec zsh
EOF
