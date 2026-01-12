#!/bin/bash

is_mainland_china() {
    # 1. 检测是否能快速访问百度（国内必通）
    if curl -s --connect-timeout 3 https://www.baidu.com >/dev/null; then
        # 2. 检测 GitHub 解析是否被污染（大陆特征：解析到非 GitHub 官方 IP）
        GITHUB_IP=$(nslookup github.com 2>/dev/null | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)
	echo "GITHUB_IP: $GITHUB_IP"
        # GitHub 官方 IP 段：140.82.0.0/16、192.30.252.0/22 等，非该段则判定为大陆
        if ! echo "$GITHUB_IP" | grep -E '^(140\.82|192\.30\.252|199\.232\.68)\.' >/dev/null; then
            return 0  # 是中国大陆网络
        fi
    fi
    return 1  # 非中国大陆网络
}
is_mainland_china
