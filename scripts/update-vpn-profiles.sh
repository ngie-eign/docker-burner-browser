#!/bin/sh

info()
{
	echo "${0##*/}: INFO: $*"
}

info "NordVPN - installing profiles."
# Ref:
# https://support.nordvpn.com/hc/en-us/articles/20164827795345-Connect-to-NordVPN-using-Linux-Terminal
zip=ovpn.zip
cd /etc/openvpn
wget -O $zip https://downloads.nordcdn.com/configs/archives/servers/ovpn.zip
unzip -f $zip
rm -f $zip
info "NordVPN - installed profiles."


