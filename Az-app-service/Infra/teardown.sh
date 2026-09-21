#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo ">> Deleting Resource group $RG"
az group delete --name "$RG" --yes --no-wait