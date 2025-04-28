#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

v=$(expr $(cd "$scriptPath"/migrations && ls | sort -g | sed 's/_.*$//' | tail -n 1) + 0)
# use MYSQL_PWD env var
dbv=$(mysql -A -r -s --skip-column-names -h$HOST -u$USER $DB -e 'select version + dirty from schema_migrations;')
if [ "$v" -eq "$dbv" ]; then
	echo "schema version matched: \"$v\"(migration scripts) VS \"$dbv\"(DB)"
	exit 0
else
	echo "schema version mis-matched: \"$v\"(migration scripts) VS \"$dbv\"(DB)"
	exit 1
fi
