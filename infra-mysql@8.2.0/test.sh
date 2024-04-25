#!/bin/bash

kubectl run mysql-client-$(date +%s) --rm --tty -i --restart='Never' --image docker.io/bitnami/mysql:8.2.0-debian-11-r0 --namespace infra-mysql --env MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace infra-mysql mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) --command -- bash -c 'mysql -h mysql.infra-mysql.svc.cluster.local -uroot -p"$MYSQL_ROOT_PASSWORD" -e "select utc_timestamp();"'
