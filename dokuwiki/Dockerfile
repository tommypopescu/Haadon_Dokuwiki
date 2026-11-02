ARG BUILD_FROM
FROM ${BUILD_FROM}

RUN apk add --no-cache \
    nginx \
    php83 \
    php83-fpm \
    php83-session \
    php83-gd \
    php83-xml \
    php83-dom \
    php83-mbstring \
    php83-openssl \
    php83-ctype \
    php83-zip \
    php83-fileinfo \
    php83-curl \
    php83-pdo \
    php83-pdo_sqlite \
    php83-sqlite3 \
    wget \
    git \
    openssh-client

# DokuWiki version — run.sh syncs bundled plugins, default template and default config
# to this version on every start so they stay consistent with the core.
ARG DOKUWIKI_VERSION=2026-07-14c
# SHA256 of the official .tgz release asset (verified against GitHub release digest).
# Update this value together with DOKUWIKI_VERSION when upgrading.
ARG DOKUWIKI_SHA256=7e9b4dcb5ecb91a57f71b9b77dcec7bcf929959881464796611349ed1d183176

RUN wget -q https://github.com/dokuwiki/dokuwiki/releases/download/release-${DOKUWIKI_VERSION}/dokuwiki-${DOKUWIKI_VERSION}.tgz -O /tmp/dokuwiki.tgz \
    && echo "${DOKUWIKI_SHA256}  /tmp/dokuwiki.tgz" | sha256sum -c - \
    && mkdir -p /var/www/dokuwiki \
    && tar -xzf /tmp/dokuwiki.tgz -C /var/www/dokuwiki --strip-components=1 \
    && rm /tmp/dokuwiki.tgz \
    && cp -r /var/www/dokuwiki /var/www/dokuwiki.dist \
    && chown -R nobody:nobody /var/www/dokuwiki

COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
