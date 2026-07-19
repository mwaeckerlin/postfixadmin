# Docker Image for Postfixadmin

Best to use in https://github.com/mwaeckerlin/mailservice

Use with https://github.com/mwaeckerlin/postfixadmin-proxy as nginx proxy in front of this

## Configuration

- `SETUP_PASSWORD`: the hashed postfixadmin setup password, no default
- `DATABASE_TYPE`: database type, default: `mysqli` - only tested with that
- `DATABASE_HOST`: name of the database host, default: `postfixadmin-db`
- `DATABASE_NAME`: name of the database, default: `postfixadmin`
- `DATABASE_USER`: name of the database user, default: `postfixadmin`
- `DATABASE_PASSWORD`: password of the database user, default: `ChangeMe`

### Setup Password

Best start with an undefined setup password, then open http://localhost:8080/public/setup.php in the browser and follow the instruction to set a setup password. At the end, you get a hash. Then set this hash to `SETUP_PASSWORD` and restart. Then open the setup again to configure an administrator.

### Database Types

- `mysql`: MySQL 3.23 and 4.0, 4.1 or 5
- `mysqli`: MySQL 4.1+ or MariaDB
- `pgsql`: PostgreSQL
- `sqlite`: SQLite 3

## Security workarounds

Active, time-boxed provisional workarounds in this image. Each is
tagged `SECURITY-WORKAROUND` at its source location and has a build
guard that fails the build after its review date so it cannot be
silently forgotten.

- **otphp audit block** (`Dockerfile`, `composer install
  --no-security-blocking`)
  - **Advisories:** GHSA-g7m4-839x-ch6v (HIGH), GHSA-2jx3-65f3-xr8r
    (MEDIUM) in `spomky-labs/otphp`.
  - **Why:** the fix exists only in otphp 11.4.3 (incompatible major);
    the Alpine `postfixadmin` package still pins otphp `^10`.
  - **Reachability (code-audited):** not reachable. Both advisories need
    `Factory::loadFromProvisioningUri` on attacker input.
    `model/TotpPf.php` uses otphp only via `TOTP::create()` /
    `TOTP::create($secret)` and `getProvisioningUri()` (output) — it
    never parses a provisioning URI and never sets `digits` from input.
  - **Remove when:** the Alpine `postfixadmin` package requires otphp
    `^11` (upstream master already does). Then drop
    `--no-security-blocking` and the guard block.
  - **Added:** 2026-07-17 — **Review by:** 2026-08-16. After that date
    the build fails on purpose; re-evaluate and, if still needed, ask
    before extending.
