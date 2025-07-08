#!/bin/bash
# Superset Initialization Script
# This script is used to initialize Superset after the containers are running

set -e

echo "Starting Superset initialization..."

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
until pg_isready -h postgres -U $POSTGRES_USER -d $POSTGRES_DB; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done
echo "PostgreSQL is ready!"

# Wait for Redis to be ready
echo "Waiting for Redis to be ready..."
until redis-cli -h redis ping; do
  echo "Redis is unavailable - sleeping"
  sleep 2
done
echo "Redis is ready!"

# Initialize the database
echo "Initializing Superset database..."
superset db upgrade

# Create admin user
echo "Creating admin user..."
superset fab create-admin \
  --username $SUPERSET_ADMIN_USER \
  --firstname $SUPERSET_ADMIN_FIRSTNAME \
  --lastname $SUPERSET_ADMIN_LASTNAME \
  --email $SUPERSET_ADMIN_EMAIL \
  --password $SUPERSET_ADMIN_PASSWORD

# Load examples if enabled
if [ "$SUPERSET_LOAD_EXAMPLES" = "true" ]; then
  echo "Loading example data..."
  superset load_examples
fi

# Initialize Superset
echo "Initializing Superset..."
superset init

echo "Superset initialization completed successfully!" 