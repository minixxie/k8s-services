#!/bin/bash

encoded=$(cat .env | base64 -w 0)

cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: hermes-agent-env
  namespace: ai-hermes-agent
type: Opaque
data:
  # Base64 encoded environment variables for hermes agent
  # To encode: echo -n "KEY=VALUE" | base64
  .env: $encoded
EOF
