#!/bin/bash

command=""

case $1 in
	record)
		command="/usr/local/bin/crecord/record.sh"
		;;
	delete)
		command="/usr/local/bin/crecord/delete.sh"
		;;
	all)
		command="/usr/local/bin/crecord/all.sh"
		;;
	uninstall)
		command="/usr/local/bin/crecord/uninstall.sh"
		;;
	*)
		echo "Usage: `basename $0` [record | delete | all | uninstall]"
		exit 1
esac

shift

$command "$@"
