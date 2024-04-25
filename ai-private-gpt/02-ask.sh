#!/bin/bash

more=""
if [ "$1" != "" ]; then
	more='"context_filter":{"docs_ids":["'$1'"]},'
fi
echo "MORE:"
echo $more

curl -X POST \
	--url "http://ai-private-gpt.local/v1/completions" \
	--header "Content-Type: application/json" \
	--header "Accept: application/json" \
	--data '
{
  "prompt": "中国舞安排",'$more'
  "use_context": true
}
'
