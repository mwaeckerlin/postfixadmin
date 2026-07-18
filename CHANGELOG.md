2026-07-17  Marc Wäckerlin

	* Build now installs the PHP dependencies past a Composer audit block:
	  the bundled one-time-password library has a published advisory whose
	  fix is only in an incompatible major version, and the affected code
	  is not reachable from PostfixAdmin's usage. The workaround is
	  time-boxed — the build deliberately fails after 2026-08-16 so it is
	  re-evaluated rather than forgotten. See README «Security workarounds».

2026-06-12  Marc Wäckerlin

	* Custom configuration is now added through a separate local
	  configuration file instead of replacing the main configuration. This
	  keeps the package defaults (among others the DKIM setting) intact;
	  previously the replacement caused a crash in the setup wizard.
	* PHP error output disabled in the FPM pool, so warnings are no longer
	  written into the HTML and JSON responses and no longer corrupt them.
	* Environment variables are passed through to the FPM worker, so the
	  database and setup configuration takes effect correctly at runtime.
