#!/bin/bash
set -e

DEST_DIR="/datascience-models/ollama"
OLLAMA_IMAGE="ollama/ollama:0.18.0"

mkdir -p "$DEST_DIR"

echo "Creating ctx32 model variants..."

nerdctl --namespace=k8s.io run --rm -it \
    --net=host \
    --user root \
    -v "$DEST_DIR:/root/.ollama" \
    --entrypoint=/bin/bash \
    "$OLLAMA_IMAGE" \
    -c "
cat > /tmp/Modelfile << 'EOF'
FROM qwen3.5:9b
PARAMETER num_ctx 32768
EOF
ollama create qwen3.5-ctx32:9b -f /tmp/Modelfile

cat > /tmp/Modelfile << 'EOF'
FROM qwen2.5-coder:7b
PARAMETER num_ctx 32768
EOF
ollama create qwen2.5-coder-ctx32:7b -f /tmp/Modelfile

echo '--- Verifying ---'
ollama list | grep ctx32
"

echo "Done. New models available on hostPath."
