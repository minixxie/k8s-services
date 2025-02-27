#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
mkdir -p DeepSeek-V2-Lite-Chat-GGUF
cd DeepSeek-V2-Lite-Chat-GGUF
wget -c https://huggingface.co/mradermacher/DeepSeek-V2-Lite-Chat-GGUF/resolve/main/DeepSeek-V2-Lite-Chat.Q4_K_M.gguf

