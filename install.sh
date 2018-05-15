#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

readonly DESTINATION="/usr/local/bin/crecord"

if [ -f helper.sh ]; then
	source helper.sh
else
	echo "Can't find helper.sh"
	exit 1
fi

echo crecord $(print_version)
echo -e "Installing in ${BOLD}$DESTINATION${NORMAL}..."
confirm

if [ ! -d "$DESTINATION" ]; then
	mkdir -v "$DESTINATION"
fi


install -v -m 755 record.sh crecord.sh delete.sh all.sh helper.sh uninstall.sh "$DESTINATION"

ln -sfv "$DESTINATION/crecord.sh" /usr/local/bin/crecord.sh
chmod +x "/usr/local/bin/crecord.sh"

echo
crecord.sh

if [ -f ascii.txt ]; then
	cat ascii.txt
fi