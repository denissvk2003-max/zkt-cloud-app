#!/bin/bash
set -e

if [ ! -f .env ]; then
  echo "ERROR: Missing .env file."
  exit 1
fi

source .env

RESOURCE_GROUP="rg-${APP_PREFIX}"

POSTGRES_SERVER=$(az postgres flexible-server list \
  --resource-group "$RESOURCE_GROUP" \
  --query "[0].name" \
  -o tsv)

DB_HOST=$(az postgres flexible-server show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$POSTGRES_SERVER" \
  --query fullyQualifiedDomainName \
  -o tsv)

mkdir -p backups

BACKUP_FILE="backups/backup-$(date +%Y%m%d-%H%M%S).sql"

echo "Creating database backup: $BACKUP_FILE"

docker run --rm postgres:16 \
  pg_dump "postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}:5432/${DB_NAME}?sslmode=require" \
  > "$BACKUP_FILE"

echo "Backup created:"
echo "$BACKUP_FILE"