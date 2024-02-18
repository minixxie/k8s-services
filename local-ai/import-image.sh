#!/bin/bash

tag=latest
nerdctl load -i local-ai.$tag.tar --namespace=k8s.io
