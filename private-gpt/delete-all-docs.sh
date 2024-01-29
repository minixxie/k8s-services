#!/bin/bash

curl -X GET --url "http://private-gpt.local/v1/ingest/list" --header "Accept: application/json" | jq '.data.[].doc_id' | sed 's/^"//' | sed 's/"$//' |
while read line
do
	echo "Deleting doc: $line"
	curl -X DELETE --url "http://private-gpt.local/v1/ingest/$line" --header "Accept: application/json"
done
