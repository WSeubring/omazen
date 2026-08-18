/* Omarchy -> Zen Browser chrome colors. Generated on every theme change.
 * Source template: ~/.config/omarchy/themed/zen.css.tpl
 * Imported by <zen profile>/chrome/userChrome.css
 */

:root,
:host(:is(.anonymous-content-host, notification-message)) {
  /* Everything in Zen derives from these three */
  --zen-primary-color: {{ accent }} !important;
  --zen-branding-dark: {{ background }} !important;
  --zen-branding-paper: {{ background }} !important;

  /* Chrome / toolbar surfaces */
  --zen-main-browser-background: {{ background }} !important;
  --zen-main-browser-background-toolbar: {{ dark_background }} !important;
  --zen-main-browser-background-old: {{ background }} !important;
  --zen-main-browser-background-toolbar-old: {{ dark_background }} !important;
  --zen-themed-toolbar-bg: {{ dark_background }} !important;
  --zen-themed-toolbar-bg-transparent: {{ background }} !important;
  --zen-urlbar-background: {{ lighter_background }} !important;
  --zen-dialog-background: {{ dark_background }} !important;
  --zen-colors-input-bg: {{ lighter_background }} !important;
  --zen-colors-border: {{ muted }} !important;

  /* Firefox lightweight-theme vars (toolbar text, urlbar, popups) */
  --lwt-accent-color: {{ background }} !important;
  --toolbar-bgcolor: {{ dark_background }} !important;
  --toolbar-color: {{ foreground }} !important;
  --toolbar-field-background-color: {{ lighter_background }} !important;
  --toolbar-field-focus-background-color: {{ lighter_background }} !important;
  --toolbar-field-color: {{ foreground }} !important;
  --toolbar-field-focus-color: {{ bright_foreground }} !important;
  --toolbar-field-border-color: {{ muted }} !important;
  --lwt-text-color: {{ foreground }} !important;
  --lwt-selected-tab-background-color: {{ lighter_background }} !important;
  --arrowpanel-background: {{ dark_background }} !important;
  --arrowpanel-color: {{ foreground }} !important;
  --arrowpanel-border-color: {{ muted }} !important;
  --panel-separator-color: {{ muted }} !important;
  --sidebar-background-color: {{ background }} !important;
  --sidebar-text-color: {{ foreground }} !important;
  --tab-selected-textcolor: {{ bright_foreground }} !important;
  --focus-outline-color: {{ accent }} !important;
  --link-color: {{ blue }} !important;
  --warning-color: {{ yellow }} !important;
  --error-color: {{ red }} !important;
  --success-color: {{ green }} !important;
}

/* The workspace gradient is written as an inline custom property on these two
 * elements by ZenGradientGenerator, which outranks anything set on :root (the
 * inline value is closer to the element). Override it there too, otherwise the
 * chrome keeps Zen's own neutral background while everything else is themed. */
#zen-browser-background {
  --zen-main-browser-background: {{ background }} !important;
  --zen-main-browser-background-old: {{ background }} !important;
}

#zen-toolbar-background {
  --zen-main-browser-background-toolbar: {{ dark_background }} !important;
  --zen-main-browser-background-toolbar-old: {{ dark_background }} !important;
}

/* Match the built-in "find bar" / notification surfaces */
findbar,
.notificationbox-stack {
  background-color: {{ dark_background }} !important;
  color: {{ foreground }} !important;
}
