# DokuWiki Home Assistant Add-on

![DokuWiki Logo](https://www.dokuwiki.org/lib/tpl/dokuwiki/images/logo.png)

A DokuWiki add-on for Home Assistant. Fork of [gregorwolf1973/Hassioadon_Dokuwiki](https://github.com/gregorwolf1973/Hassioadon_Dokuwiki) with security fixes applied.

## Security fixes (vs upstream)

- SHA256 integrity check on DokuWiki tarball download
- HTTP security headers in nginx (`X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, `Referrer-Policy`)
- User-managed config files (`local.php`, `acl.auth.php`, `users.auth.php`, `plugins.local.php`, `*.local.conf`) are preserved on restart/update
- `repository.yaml` and `config.yaml` updated to point to this fork
- Automated daily version sync via GitHub Actions

## Installation

1. Settings → Add-ons → Add-on Store → ⋮ → Repositories
2. Add URL: `https://github.com/tommypopescu/Haadon_Dokuwiki`
3. Install **DokuWiki** → Start
4. Open `http://<HA_IP>:8080/install.php` and complete the setup wizard

## Data storage

All wiki data is stored under `/share/dokuwiki/` and survives add-on reinstalls and updates.

## Updates

A GitHub Action checks for new DokuWiki releases daily and automatically updates `Dockerfile` and `config.yaml`.
With **Auto update** enabled in HA, new versions are applied automatically.
