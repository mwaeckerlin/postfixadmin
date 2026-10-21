#!/usr/bin/env bash
# imap contract: php-fpm of the image loads the imap module and knows imap_open(),
# which create_mailbox_subdirs uses.
#
# Usage: tests/imap-contract.sh IMAGE

set -uo pipefail

IMAGE="${1:?usage: tests/imap-contract.sh IMAGE}"
FAIL=0

echo "==> imap contract: ${IMAGE}"
modules=$(docker run --rm --pull=never --entrypoint /usr/sbin/php-fpm "${IMAGE}" -m 2>&1)
if grep -qx imap <<< "${modules}"; then
    echo "  PASS  imap_loaded"
else
    echo "  FAIL  imap_loaded: $(echo ${modules})"
    FAIL=1
fi
if docker run --rm --pull=never --entrypoint /usr/bin/php "${IMAGE}" -r 'exit(function_exists("imap_open") ? 0 : 1);'; then
    echo "  PASS  imap_open_exists"
else
    echo "  FAIL  imap_open_exists"
    FAIL=1
fi
exit ${FAIL}
