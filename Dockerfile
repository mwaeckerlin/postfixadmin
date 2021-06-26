FROM mwaeckerlin/very-base as build
RUN $PKG_INSTALL postfixadmin
RUN mv /usr/share/webapps/postfixadmin /root/app
RUN mkdir /root/app/templates_c
RUN $ALLOW_USER /root/app/templates_c
ADD config.inc.php /root/etc/postfixadmin/config.inc.php

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
