#!/bin/bash

startTS=$(date +"%s")

#tag=latest
tag=0.2.0

cont=0
while [ $cont ]; do
	echo "While loop..."
	nerdctl pull 3x3cut0r/privategpt:$tag --namespace=k8s.io
	cont=$?
done

endTS=$(date +"%s")
echo "Time Spent (minutes): "$(expr $(expr $endTS - $startTS) / 60)
