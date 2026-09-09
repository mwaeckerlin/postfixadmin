FROM mwaeckerlin/very-base as build
# The unversioned package names pull the current PHP, exactly as the
# php-fpm base image does it; nothing spells a version out.
RUN $PKG_INSTALL postfixadmin composer php-mysqli php-sqlite3
RUN mv /usr/share/webapps/postfixadmin /root/app
RUN cd /root/app && \
    php -r "\$c=json_decode(file_get_contents('composer.json'),true);\$c['autoload']['files']=array_values(array_filter(\$c['autoload']['files'],fn(\$f)=>\$f!=='config.inc.php'));file_put_contents('composer.json',json_encode(\$c,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));" && \
    composer install --no-dev --optimize-autoloader --no-interaction \
    --ignore-platform-reqs
RUN mkdir -p /root/var/cache/postfixadmin/templates_c
RUN $ALLOW_USER /root/var/cache/postfixadmin/templates_c
RUN mkdir -p /root/etc/postfixadmin && \
    cp /etc/postfixadmin/config.inc.php /root/etc/postfixadmin/config.inc.php
ADD config.local.php /root/etc/postfixadmin/config.local.php

FROM mwaeckerlin/php-fpm
COPY --from=build /root/ /
ENV DATABASE_TYPE "mysqli"
ENV DATABASE_HOST "postfixadmin-db"
ENV DATABASE_NAME "postfixadmin"
ENV DATABASE_USER "postfixadmin"
ENV DATABASE_PASSWORD "ChangeMe"
ENV ALIASES "0"
ENV MAILBOXES "0"
ENV MAXQUOTA "0"
ENV DOMAIN_QUOTA_DEFAULT "0"
ENV DEFAULT_ALIASES_DOMAIN ""
ENV DEFAULT_ALIASES "abuse hostmaster postmaster webmaster"
ENV VACATION_DOMAIN ""
ENV FOOTER_TEXT ""
ENV FOOTER_LINK ""
ENV WELCOME_TEXT ""
ENV SHOW_CUSTOM_DOMAINS ""
ENV SHOW_CUSTOM_COLORS ""
