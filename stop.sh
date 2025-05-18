#!/bin/bash

set -e  # Exit on error

# Function to stop process on PORT from .env
kill_process_on_port() {
  if [ -f ".env" ]; then
    PORT=$(grep -E '^PORT=' .env | cut -d '=' -f2)
    if [ -n "$PORT" ]; then
      PID=$(lsof -ti tcp:$PORT)
      if [ -n "$PID" ]; then
        echo "Stopping process on port $PORT (PID: $PID)"
        kill -9 $PID
      else
        echo "No process found on port $PORT"
      fi
    fi
  fi
}

# List of all service paths to check and kill by port
services=(
  "api-gateway"
  "services/inventory"
  "services/product"
  "services/user"
  "services/auth"
  "services/email"
)

# Loop through each service and kill based on .env port
for service in "${services[@]}"; do
  echo "Stopping service in: $service"
  cd "$service"
  kill_process_on_port
  cd - > /dev/null
done

echo "✅ All service ports have been cleaned up."
