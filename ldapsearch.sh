#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2019-02-01 16:49:45 +0000 (Fri, 01 Feb 2019)
#
#  https://github.com/harisekhon/bash-tools
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

set -euo pipefail
[ "${DEBUG:-}" = 1 ] && set -x

server="${LDAP_SERVER:-localhost}"

uri="ldap://$server"
if [ "LDAP_SSL" = 1 ]; then
    uri="ldaps://$server"
fi

domain="$(hostname -f | sed 's/^[^`.]*\.//')"

base_dn="${LDAP_BASE_DN:-dc=$(sed 's/\./,dc=/g' <<< "$domain")}"

user="${LDAP_USER:-$USER@$domain}"

set +x
if [ -z "${PASS:-}" ]; then
    read -s -p "password: " PASS
fi

if [ "${DEBUG:-}" = 1]; then
    echo "## ldapsearch -H '$uri' -b '$base_dn' -x -D '$user' -w '...' '$@'"
fi
ldapsearch -H "$uri" -b "$base_dn" -x -D "$user" -w "$PASS" "$@"
