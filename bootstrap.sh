#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"
STOW_DIR="$DOTFILES_DIR/stow"
PACKAGES=(ctags fabric ghostty git ssh tmux vim zsh)

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

mkdir -p "$HOME/.config/fabric" "$HOME/.config/ghostty" "$HOME/.nvm" "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

remove_matching_legacy_symlink "$HOME/.ctags" "$STOW_DIR/ctags/.ctags"
remove_matching_legacy_symlink "$HOME/.config/ghostty/config" "$STOW_DIR/ghostty/.config/ghostty/config"
remove_matching_legacy_symlink "$HOME/.gitconfig" "$STOW_DIR/git/.gitconfig"
remove_matching_legacy_symlink "$HOME/.gitconfig-criterian" "$STOW_DIR/git/.gitconfig-criterian"
remove_matching_legacy_symlink "$HOME/.gitconfig-tifin" "$STOW_DIR/git/.gitconfig-tifin"
remove_matching_legacy_symlink "$HOME/.gitignore" "$STOW_DIR/git/.gitignore"
remove_matching_legacy_symlink "$HOME/.ssh/config" "$STOW_DIR/ssh/.ssh/config"
remove_matching_legacy_symlink "$HOME/.tmux.conf" "$STOW_DIR/tmux/.tmux.conf"
remove_matching_legacy_symlink "$HOME/.vimrc" "$STOW_DIR/vim/.vimrc"
remove_matching_legacy_symlink "$HOME/.zshrc" "$STOW_DIR/zsh/.zshrc"

stow --dir="$STOW_DIR" --target="$HOME" --restow "${PACKAGES[@]}"

chmod 600 "$HOME/.ssh/config"

cat <<EOF
Bootstrap complete.

Next steps:
  1. Add your SSH keys to ~/.ssh so the entries in ~/.ssh/config can resolve.
  2. Install optional GUI apps you use manually (Ghostty, Rancher Desktop, Google Chrome Dev).
  3. Restart your shell with: exec zsh
EOF
