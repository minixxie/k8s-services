# NVIDIA GPU Operator for K3s

## Overview
This directory contains the Helm chart configuration for deploying NVIDIA GPU Operator on K3s with proper containerd integration.

## Version
- **GPU Operator**: v25.3.4
- **Reason for v25.3.4**: 
  - v25.10.1 has missing container images and ClusterPolicy bugs
  - v25.3.4 is stable and includes the K3s containerd socket fix

## Quick Start

### Install
```bash
cd /home/simon.tse/git/k8s-services/nvidia-gpu-operator
helm dependency update
helm install gpu-operator . -n infra-nvidia-gpu-operator --create-namespace -f values.local.yaml
```

### Upgrade
```bash
helm upgrade gpu-operator . -n infra-nvidia-gpu-operator -f values.local.yaml
```

### Uninstall
```bash
helm uninstall gpu-operator -n infra-nvidia-gpu-operator
```

## Configuration

### Important: Correct values.yaml Structure

The top-level key in `values.local.yaml` **MUST** match the subchart name in `Chart.yaml`:

```yaml
# ✅ CORRECT
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

```yaml
# ❌ WRONG - Will be ignored by Helm
nvidia-gpu-operator:
  toolkit:
    env: [...]
```

### K3s-Specific Paths
K3s uses non-standard paths for containerd:
- Socket: `/run/k3s/containerd/containerd.sock`
- Config: `/var/lib/rancher/k3s/agent/etc/containerd/config.toml`

These must be configured via environment variables in the `toolkit.env` section.

## Verification

### Check Pod Status
```bash
kubectl -n infra-nvidia-gpu-operator get pods
```

Expected output - all Running/Completed:
- gpu-operator
- gpu-feature-discovery
- nvidia-container-toolkit-daemonset (1/1 Running)
- nvidia-device-plugin-daemonset (1/1 Running)
- nvidia-dcgm-exporter (1/1 Running)
- nvidia-operator-validator (1/1 Running)
- nvidia-cuda-validator (0/1 Completed)

### Verify ClusterPolicy Configuration
```bash
kubectl get clusterpolicy cluster-policy -o yaml | grep -A15 "toolkit:"
```

Should show the env vars from values.local.yaml.

### Test GPU Access
```bash
kubectl apply -f nvidia-smi.yaml
kubectl logs job/nvidia-smi
```

Should display nvidia-smi output showing your GPU.

### Check Node Labels
```bash
kubectl get nodes -o json | jq '.items[].metadata.labels' | grep nvidia
```

Should show CUDA version, GPU count, etc.

## Files

- `Chart.yaml` - Wrapper chart that pulls gpu-operator as a dependency
- `values.local.yaml` - K3s-specific configuration with containerd paths
- `nvidia-smi.yaml` - Test job to verify GPU access
- `UPGRADE_NOTES.md` - Detailed upgrade process and troubleshooting
- `README.md` - This file

## Troubleshooting

### nvidia-container-toolkit-daemonset in CrashLoopBackOff
**Symptom**: Pod fails with "unable to dial containerd socket"

**Cause**: Incorrect containerd paths or missing env vars in ClusterPolicy

**Solution**: 
1. Verify `values.local.yaml` uses `gpu-operator:` as top-level key
2. Check env vars are in ClusterPolicy: `kubectl get clusterpolicy cluster-policy -o yaml`
3. If missing, you used wrong top-level key in values file

### Pod shows "Successfully pulled image" but stuck in Init
**Symptom**: Init containers taking long time

**Cause**: Normal - large NVIDIA images (200MB+) take time to pull

**Solution**: Wait 2-5 minutes for image pulls to complete

### GPU not detected in pods
**Symptom**: Pods can't access GPU even though operator is running

**Cause**: Node not labeled or device plugin not running

**Solution**:
1. Check node labels: `kubectl get nodes --show-labels | grep nvidia`
2. Check device plugin: `kubectl -n infra-nvidia-gpu-operator get pods | grep device-plugin`
3. Restart device plugin if needed

## System Information

Verified working on:
- **GPU**: NVIDIA GeForce RTX 4070 Laptop GPU (8GB)
- **Driver**: 550.144.03
- **CUDA**: 12.4
- **K3s**: version with containerd runtime
- **OS**: Ubuntu (K3s paths: `/var/lib/rancher/k3s/...`)

## References

- [NVIDIA GPU Operator Documentation](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/)
- [GPU Operator Release Notes](https://docs.nvidia.com/datacenter/cloud-native/gpu-operator/25.3/release-notes.html)
- [K3s with GPU Operator Issue](https://github.com/NVIDIA/gpu-operator/issues/238)
- [ClusterPolicy Helm Values Fix](https://github.com/NVIDIA/gpu-operator/issues/1694)

## Last Updated
March 10, 2026
