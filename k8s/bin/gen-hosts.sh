#!/bin/bash

cat <<EOF
## Copy and paste this section into your /etc/hosts file:
$1  k8s.local
$1  grafana.local
$1  prometheus.local
$1  mysql-exporter.local
$1  mimir.local
$1  kubeapps.local
$1  kafka-ui.local
$1  echo-server-api.local
EOF
