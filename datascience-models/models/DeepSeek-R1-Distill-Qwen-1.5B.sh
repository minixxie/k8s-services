#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

git lfs install

cd "$scriptPath"
folder=DeepSeek-R1-Distill-Qwen-1.5B
if [ -d $folder ]; then
	cd $folder && git pull --rebase && git lfs pull
else
	GIT_LFS_SKIP_SMUDGE=0 git clone --depth 1 https://huggingface.co/deepseek-ai/$folder
fi
