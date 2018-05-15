#!/bin/bash

if [ ! -f /etc/crecord.config ]; then
	echo "Can't find /etc/crecord.config"
	exit 1
fi

source /etc/crecord.config

if [ -z "$destination_folder" ]; then
	echo "destination_folder is unset"
	echo "set it in /etc/crecord.config"
	exit 1
fi

for name in "${!cameras[@]}"
do
	/usr/local/bin/crecord.d/record.sh -l -L -t 1800 -c -d "$destination_folder/$name" "${cameras[${name}]}" &
done

sleep 20
