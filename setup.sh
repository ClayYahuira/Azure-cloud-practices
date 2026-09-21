#!/usr/bin/env bash
# Laboratorio Azure App Service - setup reproducible
# Uso: source setup.sh   (para conservar las variables en tu shell)
set -euo pipefail

# --- Variables (cambia lo que quieras aqui) ---
export LOCATION="eastus"
export RG="rg-maui-practice"
export PLAN="plan-maui-practice"
# Nombre global-unico para el App Service:
export APP="app-maui-practice-$RANDOM"

echo "Region:       $LOCATION"
echo "ResourceGroup: $RG"
echo "Plan:         $PLAN"
echo "AppService:   $APP"

# --- 1a. Resource Group (GRATIS) ---
az group create --name "$RG" --location "$LOCATION" --output table
