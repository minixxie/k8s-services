#!/bin/bash

tag=latest
nerdctl save quay.io/go-skynet/local-ai:$tag --output local-ai.$tag.tar --namespace=k8s.io
