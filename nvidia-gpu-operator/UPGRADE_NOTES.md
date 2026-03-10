# NVIDIA GPU Operator Upgrade Notes

## Issue
The `nvidia-container-toolkit-daemonset` was failing with `CrashLoopBackOff` status due to:
- Unable to connect to containerd socket at `/runtime/sock-dir/containerd.sock`
- Error: `dial unix /runtime/sock-dir/containerd.sock: connect: no such file or directory`

## Root Cause
GPU Operator v24.9.2 had a bug where custom `CONTAINERD_SOCKET` environment variables were not properly propagated to the toolkit DaemonSet, and hostPath volumes were not being correctly configured for K3s paths.

## Solution
Upgraded from GPU Operator v24.9.2 to v25.3.4, which includes:
- Fix for K3s containerd socket configuration
- Proper handling of `CONTAINERD_SOCKET` and `CONTAINERD_CONFIG` environment variables
- Correct hostPath volume mounting for non-standard containerd paths

## Steps Performed

### 1. Updated Chart Version
```yaml
# Chart.yaml
version: v25.3.4
dependencies:
  - name: gpu-operator
    version: v25.3.4
    repository: https://helm.ngc.nvidia.com/nvidia
```

### 2. Fixed K3s Configuration in values.local.yaml

**IMPORTANT:** The top-level key must match the subchart name in Chart.yaml dependencies.

```yaml
# values.local.yaml
# Use "gpu-operator:" NOT "nvidia-gpu-operator:"
gpu-operator:
  operator:
    defaultRuntime: containerd
    runtimeClass: nvidia
  toolkit:
    env:
      - name: CONTAINERD_CONFIG
        value: /var/lib/rancher/k3s/agent/etc/containerd/config.toml
      - name: CONTAINERD_SOCKET
        value: /run/k3s/containerd/containerd.sock
      - name: CONTAINERD_RUNTIME_CLASS
        value: nvidia
      - name: CONTAINERD_SET_AS_DEFAULT
        value: "true"
```

**Why this matters:** The Chart.yaml uses `gpu-operator` as the dependency name, so Helm values must use that key to properly pass through to the ClusterPolicy CRD.

### 3. Updated Dependencies and Deployed
```bash
cd /home/simon.tse/git/k8s-services/nvidia-gpu-operator
helm dependency update
helm upgrade --install gpu-operator . -n infra-nvidia-gpu-operator --create-namespace -f values.local.yaml
```

### 4. ~~Patched ClusterPolicy~~ (NOT NEEDED - Issue was in values.yaml)

**INITIAL MISTAKE:** We initially thought a manual `kubectl patch` was needed, but the real issue was using the wrong top-level key in `values.local.yaml`.

**CORRECT SOLUTION:** Using `gpu-operator:` instead of `nvidia-gpu-operator:` as the top-level key in values.local.yaml ensures the environment variables are properly rendered in the ClusterPolicy CRD by Helm.

The manual patch is **NOT needed** and **should NOT be used** - it was a workaround for misconfigured Helm values.

## Verification

### 1. Check Pod Status
```bash
kubectl -n infra-nvidia-gpu-operator get pods
```
All pods should be Running/Completed:
- ✅ nvidia-container-toolkit-daemonset
- ✅ nvidia-device-plugin-daemonset
- ✅ nvidia-dcgm-exporter
- ✅ gpu-feature-discovery
- ✅ nvidia-operator-validator

### 2. Check Logs
```bash
kubectl -n infra-nvidia-gpu-operator logs -l app=nvidia-container-toolkit-daemonset
```
Should show: `Successfully signaled containerd` (no errors)

### 3. Test GPU Access
```bash
kubectl apply -f nvidia-smi.yaml
kubectl logs job/nvidia-smi
```
Should display nvidia-smi output showing GPU information.

### 4. Verify Node Labels
```bash
kubectl get nodes -o json | jq '.items[].metadata.labels' | grep nvidia
```
Should show CUDA version, GPU count, compute capability, etc.

## Current Status
- GPU Operator: v25.3.4
- CUDA Driver: 550.144.03
- CUDA Runtime: 12.4
- GPU: NVIDIA GeForce RTX 4070 Laptop GPU (8GB)
- Status: ✅ All components running successfully
- GPU Access: ✅ Verified working

## References
- [GPU Operator Issue #1694](https://github.com/NVIDIA/gpu-operator/issues/1694) - Fix for CONTAINERD_SOCKET environment variable
- [GPU Operator v25.3.4 Release Notes](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/25.3/release-notes.html)
- [K3s with GPU Operator](https://github.com/NVIDIA/gpu-operator/issues/238)

## Date
March 10, 2026
