#!/bin/bash

startTS=$(date +"%s")

#tag=latest
tag=v2.0.0-ffmpeg-core

cont=0
while [ $cont ]; do
	echo "While loop..."
	nerdctl pull quay.io/go-skynet/local-ai:$tag --namespace=k8s.io
	cont=$?
done

endTS=$(date +"%s")
echo "Time Spent (minutes): "$(expr $(expr $endTS - $startTS) / 60)
