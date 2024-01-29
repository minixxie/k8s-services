#!/bin/bash

#tag=latest
tag=0.2.0
nerdctl save 3x3cut0r/privategpt:$tag --output privategpt.$tag.tar --namespace=k8s.io
