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

/etc/init.d/crecord stop

rm -rfv /usr/local/bin/crecord*
rm -rfv /var/log/crecord
rm -fv /etc/bash_completion.d/crecord
rm -fv  /var/run/crecord.pid
rm -fv  /etc/init.d/crecord
rm -fv /usr/local/share/man/man1/crecord.1
update-rc.d -f crecord remove

echo "Do you want to uninstall /etc/crecord.config?"
confirm
rm -v /etc/crecord.config
