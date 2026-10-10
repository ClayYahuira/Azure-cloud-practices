#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"

SLOT="staging"
API_DIR="$(dirname "$0")/.."

# 1. Make sure the staging slot exists
if ! az webapp deployment slot list -g "$RG" -n "$APP" --query "[?name=='$SLOT'].name" -o tsv | grep -q .; then
  echo ">> creating slot $SLOT"
  az webapp deployment slot create -g "$RG" -n "$APP" --slot "$SLOT" --configuration-source "$APP"
fi

# 2. publish the app
echo ">> publishing"
rm -rf "$API_DIR/publish" "$API_DIR/app.zip"
dotnet publish "$API_DIR" -c Release -o "$API_DIR/publish"
( cd "$API_DIR/publish" && zip -r ../app.zip . )

# 3. Deploy to the staging slot
echo ">> deploying to slot $SLOT"
az webapp deploy -g "$RG" -n "$APP" --slot "$SLOT" --src-path "$API_DIR/app.zip" --type zip