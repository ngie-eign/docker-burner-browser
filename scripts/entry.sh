#!/bin/sh

set -ex
sudo update-vpn-profiles.sh
sudo service openvpn start
if [ $# -gt 0 ]; then
	exec "$@"
fi
