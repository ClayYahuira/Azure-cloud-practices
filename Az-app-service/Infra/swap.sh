#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

SLOT="staging"
echo ">> swapping $SLOT -> production"
az webapp deployment slot swap -g "$RG" -n "$APP" --slot "$SLOT" --target-slot production
echo ">> done -> https://$APP.azurewebsites.net"