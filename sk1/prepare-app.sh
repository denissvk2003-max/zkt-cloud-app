#!/bin/bash
set -e

echo "Preparing cloud application in Azure..."

if [ ! -f .env ]; then
  echo "ERROR: Missing .env file. Copy .env.example to .env and fill values."
  exit 1
fi

source .env

RESOURCE_GROUP="rg-${APP_PREFIX}"
CONTAINER_ENV="env-${APP_PREFIX}"
BACKEND_APP="${APP_PREFIX}-backend"
FRONTEND_APP="${APP_PREFIX}-frontend"
POSTGRES_SERVER="${APP_PREFIX}pg$RANDOM"

BACKEND_IMAGE="${DOCKERHUB_USER}/cloud-backend:latest"
FRONTEND_IMAGE="${DOCKERHUB_USER}/cloud-frontend:latest"

echo "Using resource group: $RESOURCE_GROUP"
echo "Using Docker Hub user: $DOCKERHUB_USER"

az account show > /dev/null

echo "Registering Azure providers..."
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.OperationalInsights --wait
az provider register --namespace Microsoft.DBforPostgreSQL --wait

echo "Building Docker images locally..."
docker build -t "$BACKEND_IMAGE" ./backend
docker build -t "$FRONTEND_IMAGE" ./frontend

echo "Pushing Docker images to Docker Hub..."
docker push "$BACKEND_IMAGE"
docker push "$FRONTEND_IMAGE"

echo "Creating resource group..."
az group create \
  --name "$RESOURCE_GROUP" \
  --location "$LOCATION"

echo "Creating Log Analytics workspace..."
WORKSPACE_NAME="workspace-${APP_PREFIX}"

az monitor log-analytics workspace create \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$WORKSPACE_NAME" \
  --location "$LOG_LOCATION"

WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$WORKSPACE_NAME" \
  --query customerId \
  -o tsv)

WORKSPACE_KEY=$(az monitor log-analytics workspace get-shared-keys \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$WORKSPACE_NAME" \
  --query primarySharedKey \
  -o tsv)

echo "Creating Container Apps environment..."
az containerapp env create \
  --name "$CONTAINER_ENV" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --logs-workspace-id "$WORKSPACE_ID" \
  --logs-workspace-key "$WORKSPACE_KEY"

echo "Creating PostgreSQL Flexible Server..."
az postgres flexible-server create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$POSTGRES_SERVER" \
  --location "$LOCATION" \
  --admin-user "$DB_USER" \
  --admin-password "$DB_PASSWORD" \
  --sku-name Standard_B1ms \
  --tier Burstable \
  --storage-size 32 \
  --version 16 \
  --public-access 0.0.0.0-255.255.255.255 \
  --yes

echo "Creating database..."
az postgres flexible-server db create \
  --resource-group "$RESOURCE_GROUP" \
  --server-name "$POSTGRES_SERVER" \
  --database-name "$DB_NAME"

DB_HOST=$(az postgres flexible-server show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$POSTGRES_SERVER" \
  --query fullyQualifiedDomainName \
  -o tsv)

echo "Creating backend Container App..."
az containerapp create \
  --name "$BACKEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --environment "$CONTAINER_ENV" \
  --image "$BACKEND_IMAGE" \
  --target-port 5000 \
  --ingress external \
  --min-replicas 1 \
  --max-replicas 2 \
  --cpu 0.5 \
  --memory 1.0Gi \
  --env-vars \
    DB_HOST="$DB_HOST" \
    DB_NAME="$DB_NAME" \
    DB_USER="$DB_USER" \
    DB_PASSWORD="$DB_PASSWORD" \
    DB_PORT="5432" \
    DB_SSLMODE="require"

BACKEND_FQDN=$(az containerapp show \
  --name "$BACKEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --query properties.configuration.ingress.fqdn \
  -o tsv)

BACKEND_URL="https://${BACKEND_FQDN}"

echo "Creating frontend Container App..."
az containerapp create \
  --name "$FRONTEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --environment "$CONTAINER_ENV" \
  --image "$FRONTEND_IMAGE" \
  --target-port 80 \
  --ingress external \
  --min-replicas 1 \
  --max-replicas 2 \
  --cpu 0.5 \
  --memory 1.0Gi \
  --env-vars BACKEND_URL="$BACKEND_URL"

FRONTEND_FQDN=$(az containerapp show \
  --name "$FRONTEND_APP" \
  --resource-group "$RESOURCE_GROUP" \
  --query properties.configuration.ingress.fqdn \
  -o tsv)

echo ""
echo "Application deployed successfully."
echo "Frontend URL:"
echo "https://${FRONTEND_FQDN}"
echo ""
echo "Backend health:"
echo "${BACKEND_URL}/api/health"