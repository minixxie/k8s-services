#!/bin/bash

startTS=$(date +"%s")

tag=a79e02c36dedb0b981e6cfbcd16b4010cb3a909d

cont=0
while [ $cont ]; do
	echo "While loop..."
	nerdctl pull minixxie/privategpt:$tag --namespace=k8s.io
	cont=$?
done

endTS=$(date +"%s")
echo "Time Spent (minutes): "$(expr $(expr $endTS - $startTS) / 60)
