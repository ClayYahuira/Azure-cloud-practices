#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

EMAIL="${ALERT_EMAIL:-${1:-}}"
if [[ -z "$EMAIL" ]]; then
  echo "ERROR: ALERT_EMAIL environment variable or email argument is required"
  exit 1
fi

RESOURCE_ID=$(az webapp show --name "$APP" --resource-group "$RG" --query id -o tsv)
echo ">> creating alert rule for $APP"
az monitor action-group create \
  --resource-group "$RG" --name "ag-alerts" --short-name "agalerts" \
  --action email avisos "$EMAIL" --output table
  
AG_ID=$(az monitor action-group show --resource-group "$RG" --name "ag-alerts" --query id -o tsv)

echo ">> creating alert rule for $APP (Requests > 10 per minute)"

az monitor metrics alert create \
  --resource-group "$RG" --name "request-alert" \
  --description "Alert when requests exceed 10 per minute" \
  --scopes "$RESOURCE_ID" \
  --condition "total Requests > 10" \
  --window-size 1m \
  --evaluation-frequency 1m \
  --action "$AG_ID" \
  --output table
  
echo ">> Ready. <<"
