#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMON_STOW_DIR="$DOTFILES_DIR/stow/common"
WSL_STOW_DIR="$DOTFILES_DIR/stow/wsl"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
COMMON_PACKAGES=(ctags fabric vim)
WSL_PACKAGES=(git tmux zsh)
SKIP_INSTALL=${DOTFILES_SKIP_INSTALL:-0}

if ! grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  printf 'This installer is intended for WSL.\n' >&2
  exit 1
fi

if [[ "$SKIP_INSTALL" != 1 ]]; then
  sudo apt-get update
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential ca-certificates cmake curl fd-find fzf gh git jq \
    pkg-config shellcheck stow tmux universal-ctags unzip vim zip zsh

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
      "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi

  if ! command -v uv >/dev/null 2>&1; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
  fi

  if ! command -v fnm >/dev/null 2>&1 && [[ ! -x "$HOME/.local/share/fnm/fnm" ]]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
  fi
fi

mkdir -p "$HOME/.config/fabric" "$HOME/.local/bin" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
[[ -e "$HOME/.local/bin/fd" || -L "$HOME/.local/bin/fd" ]] || \
  ln -s /usr/bin/fdfind "$HOME/.local/bin/fd"

# Keep machine-specific Git settings, including gh credentials, outside the managed file.
if [[ ! -e "$HOME/.gitconfig.local" ]]; then
  if [[ -f "$HOME/.gitconfig" && ! -L "$HOME/.gitconfig" ]]; then
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.local"
  else
    touch "$HOME/.gitconfig.local"
  fi
fi

backup_conflict() {
  local target=$1
  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR/$(dirname "${target#"$HOME"/}")"
    mv "$target" "$BACKUP_DIR/${target#"$HOME"/}"
  fi
}

for target in \
  .config/fabric/custom-patterns .ctags .gitconfig .gitignore \
  .tmux.conf .vimrc .zshrc; do
  backup_conflict "$HOME/$target"
done

stow --dir="$COMMON_STOW_DIR" --target="$HOME" --restow "${COMMON_PACKAGES[@]}"
stow --dir="$WSL_STOW_DIR" --target="$HOME" --restow "${WSL_PACKAGES[@]}"
"$DOTFILES_DIR/scripts/enable-zsh-on-wsl.sh"

if [[ -d "$BACKUP_DIR" ]]; then
  printf 'Previous files backed up in %s\n' "$BACKUP_DIR"
fi
printf 'WSL bootstrap complete. New interactive terminals will start Zsh.\n'
