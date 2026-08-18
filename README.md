# omazen

Keeps [Zen Browser](https://zen-browser.app/)'s chrome colors in sync with the
current [Omarchy](https://omarchy.org/) theme. Switch themes with
`omarchy theme set ...` and Zen follows on its next start - no per-theme
editing, no browser extension.

## Install

```bash
git clone https://github.com/WSeubring/omazen ~/Development/personal/omazen
cd ~/Development/personal/omazen && ./install.sh
```

Then restart Zen. Pass profile directories to `install.sh` to patch only some
of them; with no arguments it patches every profile under `~/.zen`.

## How it works

| Piece | Purpose |
|---|---|
| `themed/zen.css.tpl` | Symlinked to `~/.config/omarchy/themed/zen.css.tpl`. Omarchy renders every `themed/*.tpl` on each theme change, substituting that theme's colors. |
| `~/.local/state/omarchy/current/theme/zen.css` | The rendered output. Regenerated on every theme change; safe to delete. |
| `<profile>/chrome/userChrome.css` | Gets a marked block importing the rendered CSS. |
| `<profile>/user.js` | Enables `toolkit.legacyUserProfileCustomizations.stylesheets`. |
| `hooks/zen-colors` | Symlinked to `~/.config/omarchy/hooks/theme-set.d/zen-colors`. Syncs what CSS cannot hold - `zen.theme.accent-color` and `ui.systemUsesDarkTheme` - and notifies you to restart Zen. |

Zen derives `--zen-colors-*`, hover, border, input and in-content button colors
from `--zen-primary-color` plus `--zen-branding-dark` / `--zen-branding-paper`,
so the template overrides those three and then the toolbar, urlbar, panel and
lightweight-theme variables on top.

## Notes

- `userChrome.css` is read at startup only, so a theme switch shows up after
  the next Zen restart. The hook fires a notification as a reminder.
- `user.js` re-applies the accent color on every start, so an accent picked in
  Zen's own UI will not stick. Delete `~/.config/omarchy/hooks/theme-set.d/zen-colors`
  if you would rather set the accent by hand.
- A per-workspace gradient (Zen's workspace theme) paints over the browser
  background. Clear it in the workspace theme picker if colors look off.
- The template only uses colors every Omarchy theme defines, plus
  `dark_background` / `lighter_background`; themes lacking a key fall back to
  the placeholder name, so check the rendered CSS after installing an exotic
  theme.

## Uninstall

```bash
./uninstall.sh
```

Removes the symlinks, the generated CSS and the managed blocks in each profile.
Backups made by `install.sh` (`*.bak.<timestamp>`) are left alone.
