#!/bin/bash

### k8s nodes
colima stop --force
colima delete --force
make colima

### basic softwares
make local-monitoring

### the application
cd mysql && make local wait && cd -
cd java-springboot-svc && make build && cd ./k8s/ && make up && cd .. && make wait && cd ../..
cd java-springboot-svc/test && ./call-api.sh < Book.getBooks.http && cd -
