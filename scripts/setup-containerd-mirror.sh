#!/bin/bash

# ==============================================================================
#
#   setup_containerd_mirror.sh (Final Robust Version)
#
#   A robust bash script to configure registry mirrors for containerd.
#   This script is idempotent, meaning it can be safely run multiple times.
#
#   Usage:
#     1. Save this script as setup_containerd_mirror.sh
#     2. Make it executable: chmod +x setup_containerd_mirror.sh
#     3. Run it with sudo: sudo ./setup_containerd_mirror.sh
#
# ==============================================================================

# --- 配置区域 ---

# 定义 containerd 配置文件路径
CONTAINERD_CONFIG="/etc/containerd/config.toml"

# 定义要添加的镜像加速器配置
# 你可以根据需要增删或调整顺序
# 建议将你的阿里云专属加速器地址放在最前面
MIRROR_CONFIG=$(cat << 'EOF'
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://hub-mirror.c.163.com", "https://mirror.baidubce.com"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."gcr.io"]
          endpoint = ["https://gcr.m.daocloud.io"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
          endpoint = ["https://k8s-gcr.m.daocloud.io"]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."quay.io"]
          endpoint = ["https://quay.m.daocloud.io"]
EOF
)

# --- 脚本主逻辑 ---

echo "===== Starting containerd mirror configuration script ====="

# 1. 检查脚本是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root. Please use 'sudo'." >&2
    exit 1
fi

# 2. 检查 containerd 配置文件是否存在
if [ ! -f "$CONTAINERD_CONFIG" ]; then
    echo "ERROR: containerd config file not found at $CONTAINERD_CONFIG" >&2
    exit 1
fi

# 3. 检查是否已经配置过镜像加速器
# 通过查找一个唯一的镜像配置行来判断
if grep -q 'plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"' "$CONTAINERD_CONFIG"; then
    echo "INFO: Registry mirrors are already configured. Exiting."
    exit 0
fi

# 4. 自动备份原始配置文件
BACKUP_FILE="${CONTAINERD_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
echo "INFO: Backing up original config to $BACKUP_FILE"
cp "$CONTAINERD_CONFIG" "$BACKUP_FILE"

# 5. 使用临时文件和 sed 的 'r' 命令进行插入 (最可靠的方法)
echo "INFO: Adding registry mirror configuration to $CONTAINERD_CONFIG"

# 创建一个唯一的临时文件
#TMPFILE=$(mktemp)
#echo "$MIRROR_CONFIG" > "$TMPFILE"
echo "$MIRROR_CONFIG" >> "$CONTAINERD_CONFIG"

# 使用 sed 命令：
# - '/PATTERN/r FILE' 的意思是：找到匹配 PATTERN 的行后，读取并插入 FILE 文件的内容。
# - 我们在 PATTERN 后添加一个 'a\' 来先插入一个空行，以保持格式美观。
#sed -i -e '/\[plugins\."io.containerd.grpc.v1.cri"\]/a\' -e "/\[plugins\."io.containerd.grpc.v1.cri"\]/r $TMPFILE"
#mv "$TMPFILE" "$CONTAINERD_CONFIG"

# 删除临时文件
#rm -f "$TMPFILE"
