#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/variables.sh"
API_DIR="$(dirname "$0")/.."

echo ">> cleaning old artifacts"
rm -rf "$API_DIR/publish" "$API_DIR/app.zip"

echo ">> publishing Release"
dotnet publish "$API_DIR" -c Release -o "$API_DIR/publish"

echo ">> zipping publish output"
( cd "$API_DIR/publish" && zip -r ../app.zip . )

echo ">> deploying to $APP"
az webapp deploy --resource-group "$RG" --name "$APP" --src-path "$API_DIR/app.zip" --type zip

echo ">> done "
