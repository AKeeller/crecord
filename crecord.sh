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
		command="/usr/local/bin/crecord.d/all.sh"
		;;
	uninstall)
		echo -e "Uninstall with:\n\tsudo /etc/init.d/crecord uninstall"
		exit 0
		;;
	*)
		echo "Usage: `basename $0` [record | delete | all | uninstall]"
		exit 1
esac

shift

$command "$@"
