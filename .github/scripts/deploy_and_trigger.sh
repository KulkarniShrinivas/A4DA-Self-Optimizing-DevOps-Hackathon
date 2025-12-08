#!/bin/bash


set -e


echo "Retrieving secure Kestra JWT Token..."
JWT_TOKEN=$(/bin/bash .github/scripts/get_kestra_jwt.sh)

echo "Deploying to Vercel (orchestrated by Cline)..."
vercel deploy --prebuilt --prod --confirm --token "$VERCEL_TOKEN" 


echo "Triggering Kestra Codebase Health Flow using secure Bearer Token..."
KESTRA_API="${KESTRA_BASE_URL}/api/v1"
KESTRA_FLOW_ID="A4DA_CodeHealth"
KESTRA_NAMESPACE="devops.a4da" 

curl -X POST \
  -H "Authorization: Bearer $JWT_TOKEN" \
  -H "Content-Type: application/json" \
  "${KESTRA_API}/executions/${KESTRA_NAMESPACE}/${KESTRA_FLOW_ID}/create" \
  -d '{"inputs": {"githubSha": "'"${GITHUB_SHA}"'"}}' 

echo "--- A4DA-Workflow: Automation Complete ---"