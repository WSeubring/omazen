#!/bin/bash
# omazen - keep Zen Browser's chrome colors in sync with the current Omarchy theme.
#
# Symlinks the theme template and the theme-set hook into ~/.config/omarchy so
# edits in this repo take effect immediately, patches the Zen profiles, and
# renders the colors once for the theme that is active right now.
#
# Usage: ./install.sh [profile-dir ...]     (default: every profile in ~/.zen)
#        ./install.sh --help

set -euo pipefail

if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
  sed -n '2,9p' "${BASH_SOURCE[0]}" | sed 's/^# \?//'
  exit 0
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OMARCHY_CONFIG="$HOME/.config/omarchy"
TEMPLATE_LINK="$OMARCHY_CONFIG/themed/zen.css.tpl"
HOOK_LINK="$OMARCHY_CONFIG/hooks/theme-set.d/zen-colors"
GENERATED_CSS="$HOME/.local/state/omarchy/current/theme/zen.css"
MARKER="omarchy theme sync"

[[ -d $OMARCHY_CONFIG ]] || { echo "omazen: ~/.config/omarchy not found - is this Omarchy?" >&2; exit 1; }

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  [[ -L $dest || ! -e $dest ]] || cp "$dest" "$dest.bak.$(date +%s)"
  ln -sfn "$src" "$dest"
  echo "omazen: linked $dest"
}

patch_profile() {
  local profile="${1%/}"
  local chrome="$profile/chrome" user_css="$profile/chrome/userChrome.css" user_js="$profile/user.js"

  mkdir -p "$chrome"
  touch "$user_css" "$user_js"

  if ! grep -q "$MARKER" "$user_css"; then
    [[ -s $user_css ]] && cp "$user_css" "$user_css.bak.$(date +%s)"
    cat >>"$user_css" <<CSS

/* >>> $MARKER - do not edit >>> */
@import url("file://$GENERATED_CSS");
/* <<< $MARKER - do not edit <<< */
CSS
  fi

  if ! grep -q "legacyUserProfileCustomizations" "$user_js"; then
    cat >>"$user_js" <<PREFS
// >>> $MARKER - do not edit >>>
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
// <<< $MARKER - do not edit <<<
PREFS
  fi

  echo "omazen: patched $profile"
}

link "$REPO_DIR/themed/zen.css.tpl" "$TEMPLATE_LINK"
link "$REPO_DIR/hooks/zen-colors" "$HOOK_LINK"

profiles=("$@")
if ((${#profiles[@]} == 0)); then
  shopt -s nullglob
  profiles=("$HOME"/.zen/*/)
  shopt -u nullglob
fi

found=0
for profile in "${profiles[@]}"; do
  [[ -f "${profile%/}/prefs.js" ]] || continue
  patch_profile "$profile"
  found=1
done
((found)) || echo "omazen: no Zen profiles found under ~/.zen - skipped profile patching" >&2

# Render for the theme that is active now (also runs the hook).
theme_name_file="$HOME/.local/state/omarchy/current/theme.name"
if [[ -f $theme_name_file ]]; then
  omarchy theme set "$(cat "$theme_name_file")" >/dev/null 2>&1 || true
fi
[[ -f $GENERATED_CSS ]] && echo "omazen: rendered $GENERATED_CSS"

echo "omazen: done - restart Zen to pick up the colors."
