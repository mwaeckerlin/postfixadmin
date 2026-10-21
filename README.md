# Docker Image for Postfixadmin

Best to use in https://github.com/mwaeckerlin/mailservice

Use with https://github.com/mwaeckerlin/postfixadmin-proxy as nginx proxy in front of this

## Configuration

- `SETUP_PASSWORD`: the hashed postfixadmin setup password, no default
- `DATABASE_TYPE`: database type, default: `mysqli` - only tested with that
- `DATABASE_HOST`: name of the database host, default: `postfixadmin-db`
- `DATABASE_NAME`: name of the database, default: `postfixadmin`
- `DATABASE_USER`: name of the database user, default: `postfixadmin`
- `DATABASE_PASSWORD`: password of the database user, no default: an unset password fails the database connection at start
- `DATABASE_PORT`: port of the database, default: the driver's (`3306` for MySQL and MariaDB)
- `ADMIN_EMAIL`: sender of the mails PostfixAdmin sends, default: empty (PostfixAdmin then uses the address of the logged-in admin)
- `SMTP_SERVER`: SMTP server for the welcome and notification mails, default: `localhost`
- `SMTP_PORT`: port of `SMTP_SERVER`, default: `25`
- `CREATE_MAILBOX_SUBDIRS`: space-separated folders created in every new mailbox, for example `Junk Sent Trash`, default: none
- `CREATE_MAILBOX_SUBDIRS_PREFIX`: prefix of those folders, default: not set (the shipped package configuration defines no prefix); `INBOX.` for a server whose folders sit below the INBOX, empty for one whose folders sit beside it, such as the dovecot of `mwaeckerlin/mailservice`
- `IMAP_HOST`: IMAP server on which the folders are created, default: not set; give it together with `CREATE_MAILBOX_SUBDIRS`
- `IMAP_PORT`: port of `IMAP_HOST`, default: not set, so the IMAP standard port `143` applies
- `IMAP_OPTIONS`: space-separated connection options of PHP's `imap_open()` for that login, for example `novalidate-cert`, default: none

Every variable of this list that is unset keeps PostfixAdmin's own default. `tests/env-config.sh` (`npm test`) loads the shipped configuration with and without each of them and checks the resulting value.

### Setup Password

Best start with an undefined setup password, then open http://localhost:8080/public/setup.php in the browser and follow the instruction to set a setup password. At the end, you get a hash. Then set this hash to `SETUP_PASSWORD` and restart. Then open the setup again to configure an administrator.

### Folders of a New Mailbox

The image carries the PHP module `imap`, so the folders named in `CREATE_MAILBOX_SUBDIRS` are created when a mailbox is added; PostfixAdmin then logs in as the new mailbox to the IMAP server `IMAP_HOST` on `IMAP_PORT`.

### Database Types

- `mysql`: MySQL 3.23 and 4.0, 4.1 or 5
- `mysqli`: MySQL 4.1+ or MariaDB
- `pgsql`: PostgreSQL
- `sqlite`: SQLite 3

## Security workarounds

Active, time-boxed provisional workarounds in this image. Each is tagged `SECURITY-WORKAROUND` at its source location and has a build guard that fails the build after its review date so it cannot be silently forgotten.

- **otphp audit block** (`Dockerfile`, `composer install --no-security-blocking`)
  - **Advisories:** GHSA-g7m4-839x-ch6v (HIGH), GHSA-2jx3-65f3-xr8r (MEDIUM) in `spomky-labs/otphp`.
  - **Why:** the fix exists only in otphp 11.4.3 (incompatible major); the Alpine `postfixadmin` package still pins otphp `^10`.
  - **Reachability (code-audited):** not reachable. Both advisories need `Factory::loadFromProvisioningUri` on attacker input. `model/TotpPf.php` uses otphp only via `TOTP::create()` / `TOTP::create($secret)` and `getProvisioningUri()` (output) — it never parses a provisioning URI and never sets `digits` from input.
  - **Remove when:** the Alpine `postfixadmin` package requires otphp `^11` (upstream master already does). Then drop `--no-security-blocking` and the guard block.
  - **Added:** 2026-07-17 — **Review by:** 2026-08-16. After that date the build fails on purpose; re-evaluate and, if still needed, ask before extending.
