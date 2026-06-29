#!/bin/bash

source scripts/set_env.sh

curl -X POST \
"$AOAI_ENDPOINT/openai/responses?api-version=2025-04-01-preview" \
-H "Content-Type: application/json" \
-H "api-key: $AOAI_KEY" \
-d '{
  "model": "gpt-5-mini",
  "input": "Explain Kubernetes in one paragraph."
}'