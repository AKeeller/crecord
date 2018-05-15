#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

readonly DESTINATION="/usr/local/bin/crecord"

if [ -f helper.sh ]; then
	source helper.sh
	echo crecord $(print_version)...
fi

if [ ! -d "$DESTINATION" ]; then
	mkdir -v "$DESTINATION"
fi


install -v record.sh crecord.sh delete.sh all.sh helper.sh "$DESTINATION"

ln -sfv "$DESTINATION/crecord.sh" /usr/local/bin/crecord.sh

if [ -f ascii.txt ]; then
	cat ascii.txt
fi
