#!/bin/bash

if [ ! -f `dirname "$0"`/helper.sh ]; then
    echo "helper.sh not found" >&2
    exit 1
fi

source `dirname "$0"`/helper.sh

if [ ! -f /etc/crecord.config ]; then
	error "Can't find /etc/crecord.config"
	exit 1
fi

source /etc/crecord.config

if [ -z "$destination_folder" ]; then
	error "destination_folder is unset"
	echo "set it in /etc/crecord.config"
	exit 1
fi

coproc myproc {
	for name in "${!cameras[@]}"
	do
		/usr/local/bin/crecord.d/record.sh -l -L -t 1800 -c -d "$destination_folder/$name" "${cameras[${name}]}" &
	done
}

counter=${#cameras[@]}
while [ $counter -gt 0 ] && read line; do
    echo "$line"
    counter=$((counter - 1))
done <&"${myproc[0]}"
