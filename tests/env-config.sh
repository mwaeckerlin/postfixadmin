#!/usr/bin/env bash
# Environment contract: every operator setting reaches the effective
# PostfixAdmin configuration — the package default when the variable is
# unset, the operator's value when it is set.
#
# Each case runs the image's PHP with the given environment, loads the
# shipped /etc/postfixadmin/config.inc.php (which includes
# config.local.php, as the application does) and prints the resulting
# $CONF entries as JSON. `--network none` keeps the container off every
# network; `--pull=never` tests the local build.
#
# Usage: tests/env-config.sh IMAGE

set -uo pipefail

IMAGE="${1:-mwaeckerlin/postfixadmin}"

PASS=0
FAIL=0
declare -a FAILED_NAMES

_pass() { PASS=$((PASS + 1)); echo "  PASS  $1"; }
_fail() { FAIL=$((FAIL + 1)); FAILED_NAMES+=("$1"); echo "  FAIL  $1: $2"; }

_image_exists() {
    if docker image inspect "${IMAGE}" > /dev/null 2>&1; then
        return 0
    fi
    _fail "image_exists" "image not built — run 'npm run build' first"
    return 1
}

PHP_DUMP='include "/etc/postfixadmin/config.inc.php";
foreach (["database_port", "admin_email", "smtp_server", "smtp_port",
          "create_mailbox_subdirs", "create_mailbox_subdirs_prefix",
          "create_mailbox_subdirs_host", "create_mailbox_subdirs_hostport",
          "create_mailbox_subdirs_hostoptions"] as $key)
    echo $key, "=", json_encode($CONF[$key] ?? null), "\n";'

# Sets CONF to the dumped configuration for the given docker arguments.
_load() {
    CONF=$(docker run --rm --pull=never --network none --entrypoint /usr/bin/php \
               "$@" "${IMAGE}" -r "${PHP_DUMP}" 2>&1)
}

_expect() {
    local name="$1" key="$2" want="$3" got
    got=$(grep "^${key}=" <<< "${CONF}")
    if [[ "${got}" == "${key}=${want}" ]]; then
        _pass "${name}"
    else
        _fail "${name}" "'${got}', expected '${key}=${want}' (output: ${CONF})"
    fi
}

echo "==> Environment contract: settings reach the effective configuration"

_image_exists || { echo ""; echo "==> Environment contract results: 0 passed, 1 failed"; exit 1; }

_load
_expect default_database_port   database_port   'null'
_expect default_admin_email     admin_email     '""'
_expect default_smtp_server     smtp_server     '"localhost"'
_expect default_smtp_port       smtp_port       '"25"'
# The Alpine package's config.inc.php defines none of the create_mailbox_subdirs keys.
_expect default_subdirs         create_mailbox_subdirs 'null'
_expect default_subdirs_prefix  create_mailbox_subdirs_prefix 'null'
_expect default_imap_host       create_mailbox_subdirs_host 'null'
_expect default_imap_port       create_mailbox_subdirs_hostport 'null'
_expect default_imap_options    create_mailbox_subdirs_hostoptions 'null'

_load -e DATABASE_PORT=3307 \
      -e ADMIN_EMAIL=postmaster@example.com \
      -e SMTP_SERVER=postfix \
      -e SMTP_PORT=587 \
      -e CREATE_MAILBOX_SUBDIRS="Junk Sent Trash" \
      -e CREATE_MAILBOX_SUBDIRS_PREFIX= \
      -e IMAP_HOST=dovecot \
      -e IMAP_PORT=143 \
      -e IMAP_OPTIONS="novalidate-cert tls"
_expect override_database_port  database_port   '"3307"'
_expect override_admin_email    admin_email     '"postmaster@example.com"'
_expect override_smtp_server    smtp_server     '"postfix"'
_expect override_smtp_port      smtp_port       '"587"'
_expect override_subdirs        create_mailbox_subdirs '["Junk","Sent","Trash"]'
_expect override_subdirs_prefix create_mailbox_subdirs_prefix '""'
_expect override_imap_host      create_mailbox_subdirs_host '"dovecot"'
_expect override_imap_port      create_mailbox_subdirs_hostport '"143"'
_expect override_imap_options   create_mailbox_subdirs_hostoptions '["novalidate-cert","tls"]'

echo ""
echo "==> Environment contract results: ${PASS} passed, ${FAIL} failed"
if [[ ${FAIL} -gt 0 ]]; then
    echo "==> Failed checks: ${FAILED_NAMES[*]}"
    exit 1
fi
