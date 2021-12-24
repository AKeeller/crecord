#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

readonly DESTINATION="/usr/local/bin/crecord.d"

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
install -v -m 755 crecord.init /etc/init.d/crecord
install -v -m 644 bash_completion /etc/bash_completion.d/crecord
install -v -m 644 -D crecord.1 /usr/local/share/man/man1/

update-rc.d crecord defaults

mandb &> /dev/null

ln -sfv "$DESTINATION/crecord.sh" /usr/local/bin/crecord
chmod +x "/usr/local/bin/crecord"

if [ ! -f /etc/crecord.config ]; then
	cp -v crecord.config /etc/crecord.config
fi

echo
crecord

if [ -f ascii.txt ]; then
	cat ascii.txt
fi
