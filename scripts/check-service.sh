#!/bin/bash
# Usage: ./check-service.sh <service-name>
service="$1"

if [ -z "$service" ]; then
  echo "Usage: $0 <service-name>"
  exit 1
fi

if systemctl is-active --quiet "$service"; then
  echo "$service is running"
else
  echo "$service is NOT running"
  exit 1
fi
