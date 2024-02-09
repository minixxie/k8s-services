#!/bin/bash

#tag=latest
tag=0.2.0
#nerdctl save 3x3cut0r/privategpt:$tag --output privategpt.$tag.tar --namespace=k8s.io

tag=a79e02c36dedb0b981e6cfbcd16b4010cb3a909d
nerdctl save minixxie/privategpt:$tag --output minixxie.privategpt.$tag.tar --namespace=k8s.io
