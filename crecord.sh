#!/bin/bash

command=""

case $1 in
	record)
		command=`dirname $0`"/record.sh"
		;;
	delete)
		command=`dirname $0`"/delete.sh"
		;;
	all)
		command=`dirname $0`"/all.sh"
		;;
	*)
		echo "Usage: `basename $0` [record | delete | all]"
		exit 1
esac

shift

$command "$@"
