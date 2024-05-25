#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### basic softwares
make local-monitoring

### Application's dependencies
cd infra-mysql@8.2.0 && ./img && ./local && ./wait && ./test && cd -
cd infra-xxljob && ./img && ./local && ./wait && ./test && cd -

### Application
cd java-springboot-svc && make build && make up get wait && cd -
#cd java-springboot-svc/test && ./call-api.sh < Book.getBooks.http && cd -

### TESTS
cd java-springboot-svc && make test && cd - > /dev/null
