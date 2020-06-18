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

systemctl stop crecord
systemctl disable crecord

rm -fv /etc/systemd/system/crecord.service
rm -rfv /usr/local/bin/crecord*
rm -rfv /var/log/crecord
rm -fv /etc/bash_completion.d/crecord
rm -fv  /var/run/crecord.pid
rm -fv /usr/local/share/man/man1/crecord.1

systemctl daemon-reload

echo "Do you want to uninstall /etc/crecord.config?"
confirm
rm -v /etc/crecord.config
