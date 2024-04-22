#!/bin/bash

set -e

### k8s nodes
make -s k8s-redo

### basic softwares
make local-monitoring

### Application's dependencies
make -s -C ./infra-mysql@8.2.0 local wait test
make -s -C ./xxl-job local wait test

### Application
cd java-springboot-svc && make build && cd ./k8s/ && make up && cd .. && make wait && cd ..
#cd java-springboot-svc/test && ./call-api.sh < Book.getBooks.http && cd -

### TESTS
cd java-springboot-svc && make test && cd - > /dev/null
