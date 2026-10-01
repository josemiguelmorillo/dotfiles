#!/usr/bin/env bash
set -euo pipefail

# Apps that are allowed to have blank titles and should stay tiled.
keep_tiled_app_ids='
com.mitchellh.ghostty
'

aerospace list-windows --all --format '%{window-id}%{tab}%{app-bundle-id}%{tab}%{app-name}%{tab}%{window-layout}%{tab}%{window-title}' |
awk -F'\t' -v keep="$keep_tiled_app_ids" '
  $5 == "" && $4 != "floating" {
    app_id = $2

    if (keep ~ app_id) {
      next
    }

    print $1
  }
' |
while IFS= read -r window_id; do
  [ -n "$window_id" ] && aerospace layout --window-id "$window_id" floating
done

aerospace balance-sizes
