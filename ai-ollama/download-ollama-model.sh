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
OLLAMA_IMAGE="ollama/ollama:0.30.7"

mkdir -p "$DEST_DIR"

echo "Downloading models..."
nerdctl --namespace=k8s.io run --rm -it \
    --net=host \
    --user root \
    -v "$DEST_DIR:/root/.ollama" \
    --entrypoint=/bin/bash \
    "$OLLAMA_IMAGE" \
    -c "
echo '--- List existing models ---'
ollama list

echo ''
echo '--- Pulling models ---'
ollama pull gemma4:e4b
ollama pull gemma4:12b
ollama pull qwen2.5-coder:7b
ollama pull qwen3.5:9b
ollama pull deepseek-r1:14b
ollama pull llava:7b

echo ''
echo '--- Updated model list ---'
ollama list
"

echo "Done!"
