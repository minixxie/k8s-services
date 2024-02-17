#!/bin/bash

set -e

### k8s nodes
if [ "$1" == colima ]; then
	colima stop --force
	colima delete --force
	make colima
else  # assume k3s on ubuntu
	make k3s-redo
fi

### basic softwares
make local-monitoring

### Application's dependencies
cd mysql && make local wait test && cd -
cd xxl-job && make local wait test && cd -
### Application
cd java-springboot-svc && make build && cd ./k8s/ && make up && cd .. && make wait && cd ..
#cd java-springboot-svc/test && ./call-api.sh < Book.getBooks.http && cd -

### TESTS
cd java-springboot-svc && make test && cd - > /dev/null
