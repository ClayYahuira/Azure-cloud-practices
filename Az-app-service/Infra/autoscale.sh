#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

AUTOSCALE_NAME="autoscale-plan"
PLAN_ID=$(az appservice plan show --name "$PLAN" --resource-group "$RG" --query "id" -o tsv)

echo ">> removing existing autoscale settings for $PLAN"
az monitor autoscale delete --resource-group "$RG" --name "$AUTOSCALE_NAME" 2>/dev/null || true

echo ">> creating autoscale settings for $PLAN"
az monitor autoscale create \
  --resource-group "$RG" \
  --resource "$PLAN_ID" \
  --name "$AUTOSCALE_NAME" \
  --min-count 1 --max-count 2 --count 1 \
  --output table
  
echo ">> scale OUT rule (CPU > 50% -> +1 instance)"
az monitor autoscale rule create \
  --resource-group "$RG" \
  --autoscale-name "$AUTOSCALE_NAME" \
  --condition "CpuPercentage > 50 avg 5m" \
  --scale out 1 \
  
echo ">> scale IN rule (CPU < 30% -> -1 instance)"
az monitor autoscale rule create \
  --resource-group "$RG" \
  --autoscale-name "$AUTOSCALE_NAME" \
  --condition "CpuPercentage < 30 avg 5m" \
  --scale in 1 \
  
echo ">> disabling session affinity (stateless API)"
az webapp update --resource-group "$RG" --name "$APP"  --client-affinity-enabled false --output table

echo ">> done "