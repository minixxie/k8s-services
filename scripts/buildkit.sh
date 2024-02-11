#!/bin/bash

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi
set -e

cd /tmp/
curl -OL https://github.com/moby/buildkit/releases/download/v0.13.0-beta3/buildkit-v0.13.0-beta3.linux-amd64.tar.gz
exit 0
cd /usr/
tar xzvf /tmp/buildkit-v0.13.0-beta3.linux-amd64.tar.gz

cat <<EOF > /etc/systemd/system/buildkitd.service
[Unit]
Description=BuildKit
Documentation=https://github.com/moby/buildkit
After=containerd.service

[Service]
Type=notify
#ExecStart=/usr/bin/buildkitd --oci-worker=false --containerd-worker=true 
ExecStart=/usr/bin/buildkitd

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart buildkitd
systemctl enable buildkitd
systemctl status buildkitd
