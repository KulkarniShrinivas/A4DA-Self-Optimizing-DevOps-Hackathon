#!/bin/bash


set -e

KESTRA_API="${KESTRA_BASE_URL}/api/v1"

response=$(curl -s -X POST \
  -u "${KESTRA_USERNAME}:${KESTRA_PASSWORD}" \
  "${KESTRA_API}/tokens" \
  -H "accept: application/json" \
  -H "Content-Length: 0")

JWT_TOKEN=$(echo "$response" | jq -r '.token')

if [ -z "$JWT_TOKEN" ] || [ "$JWT_TOKEN" == "null" ]; then
    echo "ERROR: Failed to retrieve JWT token from Kestra API response." >&2
    echo "Response received: $response" >&2
    exit 1
fi

echo "$JWT_TOKEN"