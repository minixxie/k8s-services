#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

if [ "$(uname -s)" == Linux ]; then
	sudo ln -snf "$scriptPath"/models /datascience-models
fi
