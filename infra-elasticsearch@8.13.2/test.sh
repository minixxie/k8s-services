#!/bin/bash

kubectl run test-$(date +%s) --rm -it --restart=Never --image curlimages/curl:latest --command -- sh -c 'curl -v http://elasticsearch.infra-elasticsearch.svc.cluster.local:9200/'
