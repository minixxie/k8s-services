#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
if [ -d DeepSeek-V2-Lite ]; then
	cd DeepSeek-V2-Lite && git pull --rebase
else
	GIT_LFS_SKIP_SMUDGE=1 git clone https://huggingface.co/deepseek-ai/DeepSeek-V2-Lite
fi
