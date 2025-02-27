#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
mkdir -p DeepSeek-V3-GGUF
cd DeepSeek-V3-GGUF
for i in $(seq -w 1 9); do
	wget https://huggingface.co/unsloth/DeepSeek-V3-GGUF/resolve/main/DeepSeek-V3-Q4_K_M/DeepSeek-V3-Q4_K_M-0000${i}-of-00009.gguf
done
