#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo ">> creating resource group $RG"
az group create --name "$RG" --location "$LOCATION" --output table
