#!/bin/bash

### k8s nodes
colima stop --force
colima delete --force
make colima

### basic softwares
make -C ./ingress-controller local wait

### the application
make -C ./datascience-models up
make -C ./qdrant local wait
make -C ./mongodb local wait
make -C ./private-gpt local wait
