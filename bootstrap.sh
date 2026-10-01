#!/usr/bin/env bash

set -euo pipefail

case "$(uname -s)" in
  Darwin) exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bootstrap-macos.sh" "$@" ;;
  Linux)
    if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
      exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/bootstrap-wsl.sh" "$@"
    fi
    printf 'Unsupported Linux environment. Use bootstrap-wsl.sh only inside WSL.\n' >&2
    exit 1
    ;;
  *) printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2; exit 1 ;;
esac
