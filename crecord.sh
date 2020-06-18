#!/bin/bash

command=""

case $1 in
	record)
		command="/usr/local/bin/crecord.d/record.sh"
		;;
	delete)
		command="/usr/local/bin/crecord.d/delete.sh"
		;;
	uninstall)
		/usr/local/bin/crecord.d/uninstall.sh
		exit 0
		;;
	*)
		echo "Usage: `basename $0` [record | delete]"
		exit 1
esac

shift

$command "$@"
