FROM mwaeckerlin/php-fpm AS php-fpm-base

FROM mwaeckerlin/very-base as build
RUN $PKG_INSTALL postfixadmin composer php84-mysqli php84-sqlite3
RUN mv /usr/share/webapps/postfixadmin /root/app
# ─── SECURITY-WORKAROUND ───────────────────────────────────────────────
# Composer refuses to install spomky-labs/otphp 10.x because of
#   GHSA-g7m4-839x-ch6v  (HIGH,   DivisionByZeroError via unbounded digits)
#   GHSA-2jx3-65f3-xr8r  (MEDIUM, mass-assignment in loadFromProvisioningUri)
# Both are fixed ONLY in otphp 11.4.3 — an incompatible major. This Alpine
# postfixadmin package still pins otphp ^10 (upstream master is already on
# ^11), so we cannot upgrade without risking PostfixAdmin's 2FA code.
# Reachability: the vulnerable path parses an ATTACKER-controlled otpauth://
# provisioning URI (Factory::loadFromProvisioningUri). PostfixAdmin only
# GENERATES provisioning URIs server-side (fixed 6 digits) and verifies
# numeric codes at login — it never parses attacker URIs, so the vulnerable
# code is not reached. We therefore suppress the audit block below with
# --no-security-blocking as a documented, time-boxed provisional.
#
# Remove when: the Alpine `postfixadmin` package requires otphp ^11 — then
#              drop --no-security-blocking AND this whole block.
# Added:    2026-07-17     Review-by: 2026-08-16 (30 days)
# Register: see README.md «Security workarounds».
#
# EXPIRY GUARD — after the review date this build FAILS on purpose so the
# workaround cannot be silently forgotten. Re-check whether otphp is fixed
# and installable, then remove this block, or (only with Marc's approval)
# extend the date here and in README.md.
RUN [ "$(date +%Y%m%d)" -le "20260816" ] || { \
      echo "############################################################" ; \
      echo "SECURITY-WORKAROUND EXPIRED: otphp/postfixadmin, review-by 2026-08-16." ; \
      echo "Re-check GHSA-g7m4-839x-ch6v / GHSA-2jx3-65f3-xr8r:" ; \
      echo "  is spomky-labs/otphp fixed AND installable for this postfixadmin?" ; \
      echo "Then remove '--no-security-blocking' + this block, or ask Marc" ; \
      echo "for instructions before extending the review date." ; \
      echo "############################################################" ; \
      exit 1; }

RUN cd /root/app && \
    php84 -r "\$c=json_decode(file_get_contents('composer.json'),true);\$c['autoload']['files']=array_values(array_filter(\$c['autoload']['files'],fn(\$f)=>\$f!=='config.inc.php'));file_put_contents('composer.json',json_encode(\$c,JSON_PRETTY_PRINT|JSON_UNESCAPED_SLASHES));" && \
    composer install --no-dev --optimize-autoloader --no-interaction \
    --ignore-platform-reqs --no-security-blocking   # SECURITY-WORKAROUND (see above)
RUN mkdir -p /root/var/cache/postfixadmin/templates_c
RUN $ALLOW_USER /root/var/cache/postfixadmin/templates_c
RUN mkdir -p /root/etc/postfixadmin && \
    cp /etc/postfixadmin/config.inc.php /root/etc/postfixadmin/config.inc.php
ADD config.local.php /root/etc/postfixadmin/config.local.php
COPY --from=php-fpm-base /etc/php84/php-fpm.d/www.conf /root/etc/php84/php-fpm.d/www.conf
RUN sed -i \
    -e 's/php_admin_flag\[display_errors\] = on/php_admin_flag[display_errors] = off/' \
    -e 's/php_admin_flag\[display_startup_errors\] = on/php_admin_flag[display_startup_errors] = off/' \
    /root/etc/php84/php-fpm.d/www.conf && \
    printf '\nclear_env = no\n' >> /root/etc/php84/php-fpm.d/www.conf

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
