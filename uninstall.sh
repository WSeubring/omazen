#!/bin/bash
# Remove omazen: drop the symlinks, the generated CSS and the managed blocks
# in every Zen profile. Backups written by install.sh are left in place.

set -euo pipefail

MARKER="omarchy theme sync"
COLORS_MARKER="omarchy theme colors"

for path in "$HOME/.config/omarchy/themed/zen.css.tpl" \
            "$HOME/.config/omarchy/hooks/theme-set.d/zen-colors" \
            "$HOME/.local/state/omarchy/current/theme/zen.css"; do
  [[ -e $path || -L $path ]] || continue
  rm -f "$path"
  echo "removed $path"
done

shopt -s nullglob
for profile in "$HOME"/.zen/*/; do
  for file in "$profile/chrome/userChrome.css" "$profile/user.js"; do
    [[ -f $file ]] || continue
    grep -q "$MARKER\|$COLORS_MARKER" "$file" || continue
    tmp=$(mktemp)
    sed -e "/>>> $MARKER/,/<<< $MARKER/d" -e "/>>> $COLORS_MARKER/,/<<< $COLORS_MARKER/d" "$file" >"$tmp"
    mv "$tmp" "$file"
    echo "cleaned $file"
  done
done

echo "omazen: removed - restart Zen."
