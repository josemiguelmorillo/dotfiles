#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
COMMON_STOW_DIR="$DOTFILES_DIR/stow/common"
MACOS_STOW_DIR="$DOTFILES_DIR/stow/macos"
COMMON_PACKAGES=(ctags fabric vim)
MACOS_PACKAGES=(ghostty git kitty ssh tmux zsh)

remove_matching_legacy_symlink() {
  local target_path="$1"
  local source_path="$2"

  if [[ ! -L "$target_path" ]]; then
    return
  fi

  if cmp -s "$target_path" "$source_path"; then
    rm "$target_path"
  fi
}

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

mkdir -p "$HOME/.config/fabric" "$HOME/.config/ghostty" "$HOME/.config/kitty" "$HOME/.nvm" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

remove_matching_legacy_symlink "$HOME/.ctags" "$COMMON_STOW_DIR/ctags/.ctags"
remove_matching_legacy_symlink "$HOME/.config/ghostty/config" "$MACOS_STOW_DIR/ghostty/.config/ghostty/config"
remove_matching_legacy_symlink "$HOME/.config/kitty/kitty.conf" "$MACOS_STOW_DIR/kitty/.config/kitty/kitty.conf"
remove_matching_legacy_symlink "$HOME/.gitconfig" "$MACOS_STOW_DIR/git/.gitconfig"
remove_matching_legacy_symlink "$HOME/.gitconfig-criterian" "$MACOS_STOW_DIR/git/.gitconfig-criterian"
remove_matching_legacy_symlink "$HOME/.gitconfig-tifin" "$MACOS_STOW_DIR/git/.gitconfig-tifin"
remove_matching_legacy_symlink "$HOME/.gitignore" "$MACOS_STOW_DIR/git/.gitignore"
remove_matching_legacy_symlink "$HOME/.ssh/config" "$MACOS_STOW_DIR/ssh/.ssh/config"
remove_matching_legacy_symlink "$HOME/.tmux.conf" "$MACOS_STOW_DIR/tmux/.tmux.conf"
remove_matching_legacy_symlink "$HOME/.vimrc" "$COMMON_STOW_DIR/vim/.vimrc"
remove_matching_legacy_symlink "$HOME/.zshrc" "$MACOS_STOW_DIR/zsh/.zshrc"

stow --dir="$COMMON_STOW_DIR" --target="$HOME" --restow "${COMMON_PACKAGES[@]}"
stow --dir="$MACOS_STOW_DIR" --target="$HOME" --restow "${MACOS_PACKAGES[@]}"

chmod 600 "$HOME/.ssh/config"

cat <<EOF
Bootstrap complete.

Next steps:
  1. Add your SSH keys to ~/.ssh so the entries in ~/.ssh/config can resolve.
  2. Install optional GUI apps you use manually (Ghostty, Kitty, Rancher Desktop, Google Chrome Dev).
  3. Restart your shell with: exec zsh
EOF
