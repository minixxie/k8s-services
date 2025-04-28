#!/bin/bash

APOLLO_VER=2.4.0  # should match the tag of the container image

set -e

scriptPath=$(cd $(dirname "$0") && pwd)

# use MYSQL_PWD env var
mysql -A --default-character-set=utf8mb4 -h$HOST -u$USER < db.sql

# use MYSQL_PWD env var
mysql -A --default-character-set=utf8mb4 -h$HOST -u$USER < user.sql

cd /tmp && curl -sSLO https://raw.githubusercontent.com/apolloconfig/apollo-quick-start/refs/tags/v$APOLLO_VER/sql/apolloconfigdb.sql
sed -i 's/ApolloConfigDB/infra_apollo_config/g' /tmp/apolloconfigdb.sql
mysql -A --default-character-set=utf8mb4 -h$HOST -u$USER infra_apollo_config < /tmp/apolloconfigdb.sql

cd /tmp && curl -sSLO https://raw.githubusercontent.com/apolloconfig/apollo-quick-start/refs/tags/v$APOLLO_VER/sql/apolloportaldb.sql
sed -i 's/ApolloPortalDB/infra_apollo_portal/g' /tmp/apolloportaldb.sql
mysql -A --default-character-set=utf8mb4 -h$HOST -u$USER infra_apollo_portal < /tmp/apolloportaldb.sql
