#!/bin/bash

set -e  # Exit on error

# Function to check and create .env from .env.example
create_env_if_missing() {
  if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    echo "Creating .env from .env.example in $(pwd)"
    cp .env.example .env
  fi
}

# Function to kill any process running on the PORT from .env
kill_process_on_port() {
  if [ -f ".env" ]; then
    PORT=$(grep -E '^PORT=' .env | cut -d '=' -f2)
    if [ -n "$PORT" ]; then
      PID=$(lsof -ti tcp:$PORT)
      if [ -n "$PID" ]; then
        echo "Killing process on port $PORT (PID: $PID)"
        kill -9 $PID
      fi
    fi
  fi
}

# Step 1: Setup and run api-gateway
echo "Setting up api-gateway..."
cd api-gateway
npm install
create_env_if_missing
kill_process_on_port
npm run dev &  # Run in background
cd ..

# Step 2: Setup and run inventory service
echo "Setting up inventory service..."
cd services/inventory
npm install
create_env_if_missing
kill_process_on_port
npm run migrate:dev
npm run dev &  # Run in background
cd ../..

# Step 3: Setup and run product service
echo "Setting up product service..."
cd services/product
npm install
create_env_if_missing
kill_process_on_port
npm run migrate:dev
npm run dev &  # Run in background
cd ../..

# Step 4: Setup and run user service
echo "Setting up user service..."
cd services/user
npm install
create_env_if_missing
kill_process_on_port
npm run migrate:dev
npm run dev &  # Run in background
cd ../..

# Step 4: Setup and run user service
echo "Setting up auth service..."
cd services/auth
npm install
create_env_if_missing
kill_process_on_port
npm run migrate:dev
npm run dev &  # Run in background
cd ../..

echo "All services are starting..."

