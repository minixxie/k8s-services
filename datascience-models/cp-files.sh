#!/bin/bash

find models -type f |
while read line
do
	echo "cp: "$line
	kubectl cp $line datascience-models:/datascience-models
done
