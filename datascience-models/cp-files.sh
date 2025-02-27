#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)

if [ "$(uname -s)" != Linux ]; then
	cd "$scriptPath"/models
	find . -type f |
	while read line
	do
		echo "cp: "$line
		# Ensure the target directory exists
		kubectl exec datascience-models -- mkdir -p /datascience-models/"$(dirname "$line")"
		# Copy the file directly into the container
		kubectl exec -i datascience-models -- sh -c "cat > /datascience-models/$line" < "$line"
	done
fi
