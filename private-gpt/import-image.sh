#!/bin/bash

#tag=latest
tag=0.2.0
nerdctl load -i privategpt.$tag.tar --namespace=k8s.io
