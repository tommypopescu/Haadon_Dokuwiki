#!/bin/sh
set -e

# Persistent data in /share/dokuwiki
mkdir -p /share/dokuwiki/data/pages
mkdir -p /share/dokuwiki/data/attic
mkdir -p /share/dokuwiki/data/media
mkdir -p /share/dokuwiki/data/media_attic
mkdir -p /share/dokuwiki/data/media_meta
mkdir -p /share/dokuwiki/data/meta
mkdir -p /share/dokuwiki/data/locks
mkdir -p /share/dokuwiki/data/log
mkdir -p /share/dokuwiki/data/index
mkdir -p /share/dokuwiki/data/tmp
mkdir -p /share/dokuwiki/data/cache
mkdir -p /share/dokuwiki/conf
mkdir -p /share/dokuwiki/tpl
mkdir -p /share/dokuwiki/plugins

# Home directory for nobody — needed so git can write .gitconfig
mkdir -p /share/dokuwiki/nobody-home

# On every start, sync bundled plugins, default template and default config to the
# version shipped with this image. Files living under /share are permanent; if they
# come from a different version than the core (after an add-on update or an in-wiki
# upgrade) every page breaks with a PHP error. User-managed files are preserved.
DIST=/var/www/dokuwiki.dist
DOKUWIKI_VERSION="$(cat "$DIST/VERSION")"
echo "DokuWiki ${DOKUWIKI_VERSION}: syncing bundled plugins, default template and default config"

# Default config — only the dist defaults that DokuWiki itself overwrites on upgrades.
# User-managed files (local.php, acl.auth.php, users.auth.php, plugins.local.php,
# *.local.conf) are intentionally skipped so they survive add-on updates.
for src in "$DIST"/conf/*; do
    [ -e "$src" ] || continue
    filename="$(basename "$src")"
    case "$filename" in
        local.php|acl.auth.php|users.auth.php|plugins.local.php|*.local.conf)
            # User-managed — never overwrite
            continue
            ;;
    esac
    cp -f "$src" "/share/dokuwiki/conf/${filename}"
done

# Default template
rm -rf /share/dokuwiki/tpl/dokuwiki
cp -r "$DIST/lib/tpl/dokuwiki" /share/dokuwiki/tpl/
cp -f "$DIST/lib/tpl/index.php" /share/dokuwiki/tpl/

# Replace each bundled plugin individually so no stale files remain
for src in "$DIST"/lib/plugins/*; do
    [ -e "$src" ] || continue
    name="$(basename "$src")"
    [ -n "$name" ] || continue
    rm -rf "/share/dokuwiki/plugins/${name}"
    cp -r "$src" /share/dokuwiki/plugins/
done

# Disable the upgrade plugin: it only updates the core inside the container, which
# reverts to the image version on the next restart. DokuWiki updates come with the add-on.
if [ ! -f /share/dokuwiki/conf/plugins.protected.php ]; then
    cat > /share/dokuwiki/conf/plugins.protected.php <<'PHP'
<?php
/*
 * Created by the add-on. DokuWiki is updated via the Home Assistant add-on;
 * an in-wiki upgrade would be lost on the next restart and would cause the
 * core and plugins to diverge.
 */
$plugins['upgrade'] = 0;
PHP
fi

# Set permissions
chown -R nobody:nobody /share/dokuwiki

# Allow git operations on /share/dokuwiki/data as nobody (gitbacked plugin).
# nobody has no writable home by default (/), so we point HOME to a persistent
# directory it owns before running git config --global.
su -s /bin/sh nobody -c \
    "HOME=/share/dokuwiki/nobody-home git config --global --add safe.directory /share/dokuwiki/data" || true

# Symlinks to persistent data
rm -rf /var/www/dokuwiki/data
rm -rf /var/www/dokuwiki/conf
rm -rf /var/www/dokuwiki/lib/tpl
rm -rf /var/www/dokuwiki/lib/plugins

ln -sf /share/dokuwiki/data /var/www/dokuwiki/data
ln -sf /share/dokuwiki/conf /var/www/dokuwiki/conf
ln -sf /share/dokuwiki/tpl /var/www/dokuwiki/lib/tpl
ln -sf /share/dokuwiki/plugins /var/www/dokuwiki/lib/plugins

# nginx needs /run/nginx for its PID file (not created automatically in the container)
mkdir -p /run/nginx

# Start PHP-FPM
# Set HOME for nobody so PHP-FPM child processes (gitbacked) can write .gitconfig
export HOME=/share/dokuwiki/nobody-home
php-fpm83 -D

# Start nginx
exec nginx -g 'daemon off;'
