#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if [ -f /usr/local/bin/crecord.d/helper.sh ]; then
	source /usr/local/bin/crecord.d/helper.sh
else
	echo "Can't find helper.sh"
	exit 1
fi

echo "Uninstalling crecord $(print_version)"
confirm
rm -rfv /usr/local/bin/crecord*

echo "Do you want to uninstall /etc/crecord.config?"
confirm
rm -v /etc/crecord.config
