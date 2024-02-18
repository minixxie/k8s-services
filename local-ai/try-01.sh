#!/bin/bash

curl -v http://local-ai.local/v1/chat/completions \
	-H 'Content-Type: application/json; charset=utf-8' \
	-d '{
	"model": "ggml-koala-7b-model-q4_0-r2.bin",
	"messages": [{"role":"user", "content":"Tell me who is Einstein"}],
	"temperature": 0.7
}'
