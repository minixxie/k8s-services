#!/bin/bash

kubectl run xxljob-init-db-script --rm --tty -i --restart='Never' --image docker.io/library/mysql:8.0.31-oracle --namespace db \
	--env MYSQL_ROOT_PASSWORD=$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) \
	--command -- bash -c \
	"cd /tmp; curl -O https://raw.githubusercontent.com/xuxueli/xxl-job/master/doc/db/tables_xxl_job.sql; mysql -h mysql.db.svc.cluster.local -u root -p\$MYSQL_ROOT_PASSWORD < ./tables_xxl_job.sql; mysql -h mysql.db.svc.cluster.local -uroot -p\$MYSQL_ROOT_PASSWORD -e \"CREATE USER xxl_job; GRANT ALL ON xxl_job.* TO 'xxl_job'@'%'; ALTER USER 'xxl_job'@'%' IDENTIFIED WITH mysql_native_password BY 'xxl_job'; FLUSH PRIVILEGES;\""
