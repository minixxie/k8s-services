#!/bin/bash

set -e
sys=$(uname -s)
if [ "$sys" == "Darwin" ]; then
	echo >&2 "ERR: not implemented"
else
	sudo apt purge -q -y docker.io
	#sudo apt autoremove
fi
