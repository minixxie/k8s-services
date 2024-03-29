#!/bin/bash

curl -v http://ollama-api.local/api/generate -d '{"model":"llama2","prompt":"why is the sky blue?"}'
