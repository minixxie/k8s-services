#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/deepseek-ai/DeepSeek-V2-Lite
