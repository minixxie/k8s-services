#!/bin/bash
set -e

DEST_DIR="/datascience-models/ollama"
OLLAMA_IMAGE="ollama/ollama:0.18.0"
CONTAINER_NAME="ollama-downloader-$$"
echo "CONTAINER: $CONTAINER_NAME"

trap "nerdctl --namespace=k8s.io rm -f $CONTAINER_NAME" EXIT

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Start Ollama container in background with the volume mounted
echo "Starting Ollama container..."
nerdctl --namespace=k8s.io run -d \
    --name "$CONTAINER_NAME" \
    -v "$DEST_DIR:/root/.ollama" \
    "$OLLAMA_IMAGE"
echo "Commands:"
echo "ollama list"
echo "ollama pull xxx"
echo "ollama rm xxx"
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" bash
