#!/bin/bash

tag=cpu-v1.7.0-2024-01-06
nerdctl save siutin/stable-diffusion-webui-docker:$tag --output stable-diffusion.$tag.tar --namespace=k8s.io
