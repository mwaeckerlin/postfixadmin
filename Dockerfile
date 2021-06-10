FROM mwaeckerlin/very-base as build
RUN $PKG_INSTALL postfixadmin
RUN mv /usr/share/webapps/postfixadmin /root/app
RUN mkdir /root/app/templates_c
RUN $ALLOW_USER /root/app/templates_c
ADD config.inc.php /root/etc/postfixadmin/

FROM mwaeckerlin/php-fpm
COPY --from=build /root/ /
VOLUME [ "/app" ]
ENV DATABASE_TYPE "mysqli"
ENV DATABASE_HOST "postfixadmin-db"
ENV DATABASE_NAME "postfixadmin"
ENV DATABASE_USER "postfixadmin"
ENV DATABASE_PASSWORD "ChangeMe"
