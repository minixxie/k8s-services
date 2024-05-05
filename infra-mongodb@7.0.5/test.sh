#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

source "$scriptPath"/var.rc
cd "$scriptPath"

ts=$(date "+%s")
kubectl run mongodb-cli-$ts --rm --tty -i --restart='Never' --image mongo:7.0.5-jammy --namespace infra-mongodb --env MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace infra-mongodb mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 -d) --command -- bash -c 'mongosh "mongodb://root:$$MONGODB_ROOT_PASSWORD@mongodb.infra-mongodb.svc.cluster.local:27017/admin" --eval "db.runCommand({ping:1})"'
