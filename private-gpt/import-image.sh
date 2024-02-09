#!/bin/bash

if [ "$1" == "" ]; then
	echo >&2 "usage: $0 ./minixxie.privategpt.tag.tar"
	exit 1
fi
nerdctl load -i "$1" --namespace=k8s.io
