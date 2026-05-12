#!/bin/bash
set -e

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

echo "Delete request sent."
echo "Azure is removing all related resources in the background."