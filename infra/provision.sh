#!/usr/bin/env bash
set -euo pipefail
INFRA_DIR="$(dirname "$0")"
source "$INFRA_DIR/variables.sh"

echo ">> creating resource group $RG"
az group create --name "$RG" --location "$LOCATION" --output table

bash "$INFRA_DIR/appservice/provision.sh"
