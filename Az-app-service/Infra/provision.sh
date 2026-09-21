#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

echo ">> creating resource group $RG"
az group create --name "$RG" --location "$LOCATION" --output table

echo ">> creating App Service Plan $SKU"
az appservice plan create --name "$PLAN" --resource-group "$RG" --sku "$SKU" --is-linux --location "$LOCATION" --output table

echo ">> creating App Service $APP"
az webapp create --name "$APP" --resource-group "$RG" --plan "$PLAN" --runtime "DOTNETCORE:9.0" --https-only true --output table
