#!/bin/bash

set -e  # Exit if any command fails

# Function: Create .env from .env.example if missing
create_env_if_missing() {
  if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    echo "📄 Creating .env from .env.example in $(pwd)"
    cp .env.example .env
  fi
}

# Function: Safe npm install
safe_npm_install() {
  echo "📦 Installing dependencies in $(pwd)..."
  npm install || {
    echo "❌ npm install failed in $(pwd)"
    exit 1
  }
  echo "✅ npm install succeeded in $(pwd)"
}

# Function: Run service setup
setup_service() {
  SERVICE_PATH=$1
  echo "🔧 Setting up service: $SERVICE_PATH"
  
  if [ ! -d "$SERVICE_PATH" ]; then
    echo "❌ Directory $SERVICE_PATH not found! Skipping..."
    return
  fi

  cd "$SERVICE_PATH"
  safe_npm_install
  create_env_if_missing

  if npm run | grep -q "migrate:dev"; then
    echo "🚀 Running migration for $SERVICE_PATH"
    npm run migrate:dev
  fi

  echo "🚀 Starting dev server for $SERVICE_PATH"
  npm run dev &

  cd - > /dev/null
}

# List of services
SERVICES=(
  "api-gateway"
  "services/inventory"
  "services/product"
  "services/user"
  "services/auth"
  "services/email"
)

# Run all
for SERVICE in "${SERVICES[@]}"; do
  setup_service "$SERVICE"
done

echo "✅ All services launched."
