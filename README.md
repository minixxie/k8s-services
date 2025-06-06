# k8s-services

- [Intro](#intro)
- [Setting up k8s environment on local](#setting-up-k8s-environment-on-local)
  - [Mac](#mac)
  - [Linux](#linux)
- [Components](#components)
  - [ktransformers](#ktransformers)
  - [mysql](#mysql)
  - [mongodb](#mongodb)
  - [ollama](#ollama)


## Intro

This repository provides easy, consistent way for spinning up various common softwares for operation engineers. Since most cases helm/kustomize are being used, most components use the same Makefile (symbolic link to `scripts/Makefile` and make targets are the same).

This repository is also meant to be runnable on k8s with ArgoCD with GitOps methodology, to spin up most softwares.

## Setting up k8s environment on local
Mac
```bash
make colima
```
Mac - destroy and redo
```bash
colima stop --force
colima delete --force
make colima
```

Linux
```bash
make k3s
```
Linux - destroy and redo
```bash
make k3s-redo
```


## Components
General make targets for all components:
1. `make get` - to list out k8s resources (deployment, pod, replicaset, services, ingresses, pvc, pv, etc) and container images.
2. `make up` - to spin up as a production environment (usually uses `values.yaml`, or `kustomization/base/kustomization.yaml`).
3. `make local` (instead of `make up`) - to spin up as a local environment (usually uses `values.local.yaml`, or `kustomization/overlays/local/`).
4. `make down` - to shutdown the component
5. `make img` - to pull the container image upfront, and save it as a file on local harddrive (to speed up next pull).
6. `make test` - to run relevant test to verify the deployment was successful.
7. `make cli` - run command line interface (if any).


### ktransformers
Link: https://github.com/kvcache-ai/ktransformers/

Preparations:

1. make sure k3s is running (e.g. Linux)
```bash
make k3s-redo
```
2. make sure GPU operator is deployed to configure NVIDIA drivers (assumption: you have `nvidia-drivers-550` already installed on the host machine, e.g. `sudo apt-get install nvidia-drivers-550`)
```bash
cd nvidia-gpu-operator/
make img local wait test
cd -
```

3. make sure relevant model files are downloaded into the pv (persistent volume)
```bash
cd datascience-models/
cd models/
./DeepSeek-V3.sh       # download the repo
./DeepSeek-V3-GGUF.sh  # download the GGUF files
cd ..
make local test        # setup pv and pvc
cd ..
```

4. deploy the k8s components
```bash
cd ai-ktransformers/
make img local test
cd ..
```

5. you can play with the API
```bash
./test "Tell me what is MoE in Machine Learning"
```

*The above commands can actually be replaced by running:
```bash
./tests/e2e.ktransformers.sh
```

### mysql
Spin up on local machine
```bash
cd infra-mysql@8.2.0/
make local
```
Spin up on local machine, with mysql-exporter
```bash
make mysql
```
Destroy
```bash
cd infra-mysql@8.2.0/
make down
```
Show k8s resources
```bash
cd infra-mysql@8.2.0/
make get

----------------------------------------
kubectl -n $(make -s ns) get all
NAME          READY   STATUS    RESTARTS   AGE
pod/mysql-0   1/1     Running   0          104s

NAME                     TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
service/mysql-headless   ClusterIP   None         <none>        3306/TCP   104s
service/mysql            ClusterIP   10.43.30.6   <none>        3306/TCP   104s

NAME                     READY   AGE
statefulset.apps/mysql   1/1     104s
----------------------------------------
kubectl -n $(make -s ns) get ing
No resources found in infra-mysql namespace.
----------------------------------------
kubectl -n $(make -s ns) get pvc
NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
data-mysql-0   Bound    pvc-fdad5a94-824f-4cc5-a3b0-1dca064975e3   8Gi        RWO            local-path     104s
----------------------------------------
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   REASON   AGE
pvc-fdad5a94-824f-4cc5-a3b0-1dca064975e3   8Gi        RWO            Delete           Bound    infra-mysql/data-mysql-0   local-path              96s
----------------------------------------
if [ -f get.rc ]; then source get.rc; fi
```
mysql cli
```bash
cd infra-mysql@8.2.0/
make cli
```

### mongodb
Spin up on local machine
```bash
cd infra-mongodb@7.0.5/
make local
```
Destroy
```bash
cd infra-mongodb@7.0.5/
make down
```
Show k8s resources
```bash
cd infra-mongodb@7.0.5/
make get

----------------------------------------
kubectl -n $(make -s ns) get all
NAME            READY   STATUS    RESTARTS   AGE
pod/mongodb-0   1/1     Running   0          35s

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)     AGE
service/mongodb   ClusterIP   10.43.209.29   <none>        27017/TCP   35s

NAME                       READY   AGE
statefulset.apps/mongodb   1/1     35s
----------------------------------------
kubectl -n $(make -s ns) get ing
No resources found in db namespace.
----------------------------------------
kubectl -n $(make -s ns) get pvc
NAME                STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
datadir-mongodb-0   Bound    pvc-c21e8702-999e-4943-87a3-a69bbb8b6474   8Gi        RWO            local-path     35s
----------------------------------------
kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                      STORAGECLASS   REASON   AGE
pvc-c21e8702-999e-4943-87a3-a69bbb8b6474   8Gi        RWO            Delete           Bound    db/datadir-mongodb-0       local-path              33s
----------------------------------------
if [ -f get.rc ]; then source get.rc; fi

```
mongodb cli
```bash
cd infra-mongodb@7.0.5/
make cli

if [ -f cli.rc ]; then source cli.rc; fi
If you don't see a command prompt, try pressing enter.
admin> show dbs;
admin   100.00 KiB
config   12.00 KiB
local    40.00 KiB
admin> 
```


### ollama
With ollama, you may add models on your own, please refer to: https://ollama.com/search
and configure in `values.yaml` / `values.local.yaml`.

Spin up on local machine
```bash
# ollama will download models from the internet, it needs long time to be pod ready
cd ai-ollama
make local
```

Destory
```bash
cd ai-ollama
make down
```
Show k8s resources:
```bash
cd ai-ollama && make get

----------------------------------------
kubectl -n $(make -s ns) get all
NAME                          READY   STATUS    RESTARTS   AGE
pod/ollama-7cd6c64695-f9bwq   1/1     Running   0          11h

NAME             TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)     AGE
service/ollama   ClusterIP   10.43.35.67   <none>        11434/TCP   11h

NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ollama   1/1     1            1           11h

NAME                                DESIRED   CURRENT   READY   AGE
replicaset.apps/ollama-7cd6c64695   1         1         1       11h
----------------------------------------
kubectl -n $(make -s ns) get ing
NAME     CLASS     HOSTS              ADDRESS         PORTS   AGE
ollama   traefik   ollama-api.local   192.168.3.128   80      11h
----------------------------------------
kubectl -n $(make -s ns) get pvc
No resources found in ai-ollama namespace.
----------------------------------------
kubectl get pv
No resources found
----------------------------------------
if [ -f get.rc ]; then source get.rc; fi
```
To test (with `127.0.0.1  ollama-api.local` in `/etc/hosts`):
```bash
cd ai-ollama
./test.sh

* processing: http://ollama-api.local/api/generate
*   Trying 127.0.0.1:80...
* Connected to ollama-api.local (127.0.0.1) port 80
> POST /api/generate HTTP/1.1
> Host: ollama-api.local
> User-Agent: curl/8.2.1
> Accept: */*
> Content-Length: 50
> Content-Type: application/x-www-form-urlencoded
> 
< HTTP/1.1 200 OK
< Content-Type: application/x-ndjson
< Date: Fri, 29 Mar 2024 03:24:08 GMT
< Transfer-Encoding: chunked
< 
{"model":"llama2","created_at":"2024-03-29T03:24:08.427451961Z","response":"\n","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:08.929457502Z","response":"The","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:09.439385692Z","response":" sky","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:10.027851422Z","response":" appears","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:10.640386355Z","response":" blue","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:11.330515223Z","response":" to","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:11.921239622Z","response":" us","done":false}
{"model":"llama2","created_at":"2024-03-29T03:24:12.522344661Z","response":" because","done":false}
...
```

*Edit values.yaml / values.local.yaml to control what models to be served.
