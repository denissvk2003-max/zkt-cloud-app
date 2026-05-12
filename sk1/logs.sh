#!/bin/bash
set -e

if [ ! -f .env ]; then
  echo "ERROR: Missing .env file."
  exit 1
fi

source .env

RESOURCE_GROUP="rg-${APP_PREFIX}"
FRONTEND_APP="${APP_PREFIX}-frontend"
BACKEND_APP="${APP_PREFIX}-backend"

echo "Frontend logs:"
az containerapp logs show \
  --name "$FRONTEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --follow false \
  --tail 50

echo ""
echo "Backend logs:"
az containerapp logs show \
  --name "$BACKEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --follow false \
  --tail 50