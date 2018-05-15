#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if [ -f helper.sh ]; then
	source helper.sh
else
	echo "Can't find helper.sh"
	exit 1
fi

echo "Uninstalling crecord $(print_version)"
confirm
rm -rfv /usr/local/bin/crecord*
