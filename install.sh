#!/bin/bash

readonly DESTINATION="/usr/local/bin/crecord"

if [ -f helper.sh ]; then
	source helper.sh
	echo crecord $(print_version)...
fi

if [ ! -d "$DESTINATION" ]; then
	mkdir -v "$DESTINATION"
fi


install -v record.sh crecord.sh all.sh helper.sh "$DESTINATION"

ln -sv "$DESTINATION/crecord.sh" /usr/local/bin/crecord.sh
