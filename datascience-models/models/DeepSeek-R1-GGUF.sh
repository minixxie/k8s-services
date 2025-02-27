#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
mkdir -p DeepSeek-R1-GGUF
cd DeepSeek-R1-GGUF
for i in $(seq -w 1 9); do
	wget https://huggingface.co/unsloth/DeepSeek-R1-GGUF/resolve/main/DeepSeek-R1-Q4_K_M/DeepSeek-R1-Q4_K_M-0000${i}-of-00009.gguf
done
