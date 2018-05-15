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
		command="/usr/local/bin/crecord.d/uninstall.sh"
		;;
	*)
		echo "Usage: `basename $0` [record | delete | all | uninstall]"
		exit 1
esac

shift

$command "$@"
