#!/bin/bash
declare -A cameras=(
	["cancellone"]="192.168.0.91"
	["strada"]="192.168.0.92"
	["bagno azzurro"]="192.168.0.93"
	["terrazzo"]="192.168.0.94"
	["garage"]="192.168.0.95"
	["bagno rosa"]="192.168.0.96"
	["ingresso"]="192.168.0.97"
	["salone"]="192.168.0.98"
)

for name in "${!cameras[@]}"
do
	./record.sh -q -t 1800 -c -d "../$name" "${cameras[${name}]}" &
done

sleep 20
