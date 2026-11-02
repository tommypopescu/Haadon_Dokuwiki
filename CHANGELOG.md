# Changelog

## 1.1.1

- Fix: plugin endpoints that derive `DOKU_INC` from `__DIR__` (e.g. `lib/plugins/mcp/mcp.php`) failed with `Failed opening required '.../inc/init.php'`, because `lib/plugins` is a symlink to `/share/dokuwiki/plugins`. `DOKU_INC` is now defined via `auto_prepend_file` for scripts under `/lib/plugins/`.

## 1.0.6

- PHP extensions `pdo`, `pdo_sqlite`, `sqlite3` and `curl` added.
- Security: SHA256 integrity check added to DokuWiki tarball download.
- Security: HTTP security headers added to nginx (`X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`).
- Security: User-managed config files (`local.php`, `acl.auth.php`, `users.auth.php`, `plugins.local.php`, `*.local.conf`) are now preserved when syncing default config on restart.
- Automated daily DokuWiki version update via GitHub Actions.
- `repository.yaml` and `config.yaml` updated to point to this fork.

## 1.0.5 (upstream)

- DokuWiki 2024-02-06b → **2026-07-14c “Mort”**.
- Fix: bundled plugins, default template and default config are now synced to the image version on every start.
- Upgrade plugin disabled via `conf/plugins.protected.php`.

## 1.0.4 (upstream)

- Added `php83-dom` module.

## 1.0.3 (upstream)

- Removed `armv7` from `build.yaml`.

## 1.0.2 (upstream)

- Added `url` key to add-on config.

## 1.0.1 (upstream)

- Removed non-existent `php83-json` package.
- nginx: internal directory block moved before PHP locations.
- `/run/nginx` created before start.
- Base image updated to 16.3.6.

## 1.0.0 (upstream)

- Initial release: DokuWiki 2024-02-06b with nginx + PHP 8.3 FPM.
