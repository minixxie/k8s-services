#!/bin/bash

curl -X POST \
	--url "http://private-gpt.local/v1/ingest/text" \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--data '
{
  "file_name": "Student winter uniform requirements",
  "text": "Boys students need to wear white long sleeves shirt, and gray long pants. While girl students need to wear pale blue long sleeves shirt, and dark blue skirt. Both boys and girls need to wear a tie."
}
'

curl -X POST \
	--url "http://private-gpt.local/v1/ingest/text" \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--data '
{
  "file_name": "Chinese dance training on Saturday",
  "text": "The Chinese dance school team has training on every Saturday from 9:30 am to 5:00 pm. Students please bring your money to buy lunch."
}
'

curl -X GET --url "http://private-gpt.local/v1/ingest/list" --header "Accept: application/json"
