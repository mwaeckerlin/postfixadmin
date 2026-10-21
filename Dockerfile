FROM mwaeckerlin/very-base AS build
# The unversioned package names pull the current PHP, exactly as the
# php-fpm base image does it; the version is then read from the file
# system wherever it has to be spelled out.
RUN $PKG_INSTALL postfixadmin composer php-mysqli php-sqlite3
RUN mv /usr/share/webapps/postfixadmin /root/app
# The former otphp workaround is gone: the Alpine postfixadmin package now
# requires spomky-labs/otphp ^11 and resolves to 11.5.0, so both advisories
# (GHSA-g7m4-839x-ch6v, GHSA-2jx3-65f3-xr8r, fixed in 11.4.3) no longer
# apply and the audit passes without any suppression.
RUN cd /root/app && \
    php -r "\$c=json_decode(file_get_contents('composer.json'),true);\$c['autoload']['files']=array_values(array_filter(\$c['autoload']['files'],fn(\$f)=>\$f!=='config.inc.php'));file_put_contents('composer.json',json_encode(\$c,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));" && \
    composer install --no-dev --optimize-autoloader --no-interaction \
    --ignore-platform-reqs
RUN mkdir -p /root/var/cache/postfixadmin/templates_c
RUN $ALLOW_USER /root/var/cache/postfixadmin/templates_c
RUN mkdir -p /root/etc/postfixadmin && \
    cp /etc/postfixadmin/config.inc.php /root/etc/postfixadmin/config.inc.php
ADD config.local.php /root/etc/postfixadmin/config.local.php

# create_mailbox_subdirs creates the folders of a new mailbox with imap_open()
FROM php:fpm-alpine AS imap
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/install-php-extensions
RUN install-php-extensions imap \
    && mkdir -p /root/imap \
    && tar cph \
        "$(php-config --extension-dir)/imap.so" \
        /usr/local/etc/php/conf.d/docker-php-ext-imap.ini \
        $(ldd "$(php-config --extension-dir)/imap.so" | sed -n 's,.* => \([^ ]*\) .*,\1,p') \
    | tar xpC /root/imap/

FROM mwaeckerlin/php-fpm
COPY --from=imap /root/imap/ /
COPY --from=build /root/ /
ENV DATABASE_TYPE="mysqli"
ENV DATABASE_HOST="postfixadmin-db"
ENV DATABASE_NAME="postfixadmin"
ENV DATABASE_USER="postfixadmin"
# No default DB password: a shipped default credential is the dangerous
# case (a copy-paste deployment where the DB image happens to set the
# same one). DATABASE_PASSWORD is not set in the image, so the DB
# connection fails loudly and early (fail-fast) instead of coming up on a
# publicly known password. The operator MUST set it explicitly. See README.
ENV ALIASES="0"
ENV MAILBOXES="0"
ENV MAXQUOTA="0"
ENV DOMAIN_QUOTA_DEFAULT="0"
ENV DEFAULT_ALIASES_DOMAIN=""
ENV DEFAULT_ALIASES="abuse hostmaster postmaster webmaster"
ENV VACATION_DOMAIN=""
ENV FOOTER_TEXT=""
ENV FOOTER_LINK=""
ENV WELCOME_TEXT=""
ENV SHOW_CUSTOM_DOMAINS=""
ENV SHOW_CUSTOM_COLORS=""
