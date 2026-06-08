#!/bin/bash

kubectl -n ai-ollama port-forward service/ollama 11434:11434
