#!/bin/bash
set -e

# Array of models to download in format "model:tag"
# MODELS=(
#   "deepseek-r1:14b"
#   # "drivedenpadev/deepseek-v3.2:latest"
#   # "deepseek-r1:7b"
#   # "llama3.2:3b"
#   # "qwen2.5-coder:7b"
# )

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
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama list
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama pull qwen2.5:14b
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama pull qwen3.5:9b
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama pull deepseek-r1:14b
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama pull llava:7b
nerdctl --namespace=k8s.io exec -it "$CONTAINER_NAME" ollama list
