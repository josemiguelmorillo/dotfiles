#!/usr/bin/env bash

set -euo pipefail

bashrc=${1:-"$HOME/.bashrc"}

if [[ -L "$bashrc" ]]; then
  printf 'Refusing to replace a symlink: %s\n' "$bashrc" >&2
  exit 1
fi

# Earlier WSL installs may already have the same handoff without a marker.
if [[ -f "$bashrc" ]] && grep -Fq 'BASH_TO_ZSH_DISABLE' "$bashrc"; then
  exit 0
fi

tmpfile=$(mktemp "${bashrc}.tmp.XXXXXX")
trap 'rm -f "$tmpfile"' EXIT

cat > "$tmpfile" <<'HANDOFF'
# dotfiles: start Zsh in interactive WSL terminals.
if [[ $- == *i* && -t 0 && -x /usr/bin/zsh && -z ${BASH_TO_ZSH_DISABLE:-} ]]; then
    exec /usr/bin/zsh -l
fi

HANDOFF

if [[ -f "$bashrc" ]]; then
  cat "$bashrc" >> "$tmpfile"
  chmod --reference="$bashrc" "$tmpfile"
fi
mv "$tmpfile" "$bashrc"
trap - EXIT
