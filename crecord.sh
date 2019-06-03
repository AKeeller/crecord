#!/bin/bash

command=""

case $1 in
	record)
		command="/usr/local/bin/crecord.d/record.sh"
		;;
	delete)
		command="/usr/local/bin/crecord.d/delete.sh"
		;;
	all)
		echo -e "crecord all is now deprecated. Use\n\n\tsudo /etc/init.d/crecord start\n\ninstead. If you want anyway to manually start crecord all, use\n\n\t/usr/local/bin/crecord.d/all.sh"
		exit 0
		;;
	uninstall)
		echo -e "Uninstall with:\n\tsudo /etc/init.d/crecord uninstall"
		exit 0
		;;
	*)
		echo "Usage: `basename $0` [record | delete]"
		exit 1
esac

shift

$command "$@"
