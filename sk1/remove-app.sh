#!/bin/bash
set -e

# Render služby sa v tomto riešení odstraňujú cez Render Dashboard.
# Skript slúži ako návod na zrušenie všetkých vytvorených služieb.

if [ ! -f .env ]; then
  echo "ERROR: Missing .env file."
  exit 1
fi

source .env

RESOURCE_GROUP="rg-${APP_PREFIX}"

echo "Removing cloud application..."
echo "Deleting resource group: $RESOURCE_GROUP"

az group delete \
  --name "$RESOURCE_GROUP" \
  --yes \
  --no-wait
z
echo "Render resources are managed by Render Blueprint."
echo "To remove the app:"
echo "1. Open Render Dashboard"
echo "2. Open the Blueprint/project"
echo "3. Delete frontend service, backend service and PostgreSQL database"
echo "4. Confirm deletion"