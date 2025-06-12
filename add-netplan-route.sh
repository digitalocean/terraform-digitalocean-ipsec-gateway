#!/bin/bash
set -euo pipefail

if [ "$#" -lt 3 ]; then
  echo "Usage: $0 <IFACE> <DEST_CIDR> <GATEWAY_OR_DEV>"
  exit 1
fi

IFACE="$1"
DEST="$2"
NEXT_HOP="$3"

SAFE_DEST="${DEST//\//-}"
FILENAME="/etc/netplan/60-route-${IFACE}-${SAFE_DEST}.yaml"

if [[ "${NEXT_HOP}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  cat > "${FILENAME}" <<EOF
network:
  version: 2
  ethernets:
    ${IFACE}:
      routes:
        - to: ${DEST}
          via: ${NEXT_HOP}
EOF
  echo "Wrote ${FILENAME} (via ${NEXT_HOP}) for ${IFACE} => ${DEST}"
else
  cat > "${FILENAME}" <<EOF
network:
  version: 2
  ethernets:
    ${IFACE}:
      routes:
        - to: ${DEST}
          via: 0.0.0.0
          scope: link
EOF
  echo "Wrote ${FILENAME} (scope: link) for ${IFACE} => ${DEST}"
fi

echo "Applying netplan"
netplan apply

echo "Done."