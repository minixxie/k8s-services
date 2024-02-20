#!/bin/bash

tag=cuda-v1.7.0-2024-01-06
tag=cpu-v1.7.0-2024-01-06
nerdctl pull siutin/stable-diffusion-webui-docker:$tag --namespace=k8s.io
