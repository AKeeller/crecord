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
	*)
		echo "Usage: `basename $0` [record | delete | all]"
		exit 1
esac

shift

$command "$@"
