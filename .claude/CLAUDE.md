# Runs on Data — Hugo Blog

## Dark Mode

The Paper theme toggles dark mode via a `.dark` class on `<html>`, not `@media (prefers-color-scheme)`.

When writing inline `<style>` blocks or raw HTML in posts:

- **Never hardcode light-mode colors** (e.g. `background: #f3f4f6`) without a `.dark` counterpart.
- For one-off HTML elements (chat boxes, callouts), use `color-mix(in srgb, currentColor 10%, transparent)` which adapts automatically.
- For larger custom CSS blocks (like the transcript post), add a `/* Dark mode */` section with `.dark .your-class` selectors using dark palette equivalents.
- SVG elements need attribute selectors to override inline `fill`/`stroke` values, e.g. `.dark .my-svg text[fill="#111827"] { fill: #e5e7eb; }`.

## Hugo Version

Keep the Hugo version in sync between local (`flake.nix`/`flake.lock`) and CI (`HUGO_VERSION` in `.github/workflows/hugo.yaml`) — version skew silently breaks deploys when a template uses an API that only exists in one of them.

## Hugo Theme Overrides

Template overrides live in `layouts/_default/` and are full copies of `themes/paper/layouts/_default/` files with small changes. Each override has a `{{/* Override: ... */}}` comment explaining what changed. Keep this convention when adding new overrides.
