#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

cd "$scriptPath"
if [ -d DeepSeek-R1 ]; then
	cd DeepSeek-R1 && git pull --rebase
else
	GIT_LFS_SKIP_SMUDGE=1 git clone --depth 1 https://huggingface.co/deepseek-ai/DeepSeek-R1
fi
