# Changelog

- 2026-10-21 **3.5.2**
    - The weekly rebuild also starts the version line 1, published as `mwaeckerlin/postfixadmin:1`, which until now got no rebuild and so no security fix of its base image

- 2026-09-26 **3.5.1**
    - The image is published for amd64 and arm64 under one tag, built, tested and published automatically on every change and every week
    - A test verifies that the shipped image contains no shell, busybox or perl
    - Image build no longer emits warnings: modernized instruction format, and `DATABASE_PASSWORD` is no longer set in the image at all, which behaves like the empty value before

- 2026-07-20 **no default database password**
    - The image no longer ships a default `DATABASE_PASSWORD` — an unset
      value now fails the DB connection loudly and early (fail-fast)
      instead of coming up on a publicly known credential. Operators
      must set `DATABASE_PASSWORD` explicitly.

- 2026-07-17 Marc Wäckerlin
    - Build now installs the PHP dependencies past a Composer audit block:
      the bundled one-time-password library has a published advisory whose
      fix is only in an incompatible major version, and the affected code
      is not reachable from PostfixAdmin's usage. The workaround is
      time-boxed — the build deliberately fails after 2026-08-16 so it is
      re-evaluated rather than forgotten. See README «Security workarounds».

- 2026-06-12 Marc Wäckerlin
    - Custom configuration is now added through a separate local
      configuration file instead of replacing the main configuration. This
      keeps the package defaults (among others the DKIM setting) intact;
      previously the replacement caused a crash in the setup wizard.
    - PHP error output disabled in the FPM pool, so warnings are no longer
      written into the HTML and JSON responses and no longer corrupt them.
    - Environment variables are passed through to the FPM worker, so the
      database and setup configuration takes effect correctly at runtime.
