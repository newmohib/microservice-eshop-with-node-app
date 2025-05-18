#!/bin/bash

set -e  # Exit on any unexpected error

# Function to stop process on PORT from .env
kill_process_on_port() {
  if [ -f ".env" ]; then
    PORT=$(grep -E '^PORT=' .env | cut -d '=' -f2)
    if [ -n "$PORT" ]; then
      PID=$(lsof -ti tcp:$PORT)
      if [ -n "$PID" ]; then
        echo "🔴 Stopping process on port $PORT (PID: $PID)"
        kill -9 $PID
      else
        echo "ℹ️  No process found on port $PORT"
      fi
    fi
  fi
}

# List of all service paths
services=(
  "api-gateway"
  "services/inventory"
  "services/product"
  "services/user"
  "services/auth"
  "services/email"
)

# Loop through each service
for service in "${services[@]}"; do
  echo "⏹️  Stopping service in: $service"

  if [ -d "$service" ]; then
    cd "$service"
    kill_process_on_port
    cd - > /dev/null
  else
    echo "⚠️  Directory $service not found. Skipping..."
  fi
done

echo "✅ All service ports have been cleaned up."

# # Stop any running services
# echo "🛑 Running stop.sh to stop any running services first..."
# chmod +x stop.sh && ./stop.sh