#!/bin/bash
destination_folder=""
readonly min_default=240
min=$min_default  # delete files older than $min minutes
format="mp4"
yes=false

source `dirname $0`/helper.sh

function print_usage {
    echo -e "Usage: `basename $0` [options]
     options:
      ${BOLD}-h${NORMAL}\t\t\thelp
      ${BOLD}-d destination_folder${NORMAL}\tset root folder of records
      ${BOLD}-m min${NORMAL}\t\t\tdelete files older than min (default: $min_default)
      ${BOLD}-f format${NORMAL}\t\t\tdelete files with extension ${BOLD}format${NORMAL}
      ${BOLD}-y${NORMAL}\t\t\tsay yes to all"
}

function print_status {
    echo -e "${GREEN}$destination_folder${NORMAL}, files older than ${GREEN}$min${NORMAL} minutes in ${GREEN}$format${NORMAL} format"
}

function confirm {
	read -p "Continue? [Y/n]: " continue
	if [ $continue = "y" -o $continue = "Y" ]; then
		echo "Performing deletion..."

	else
		echo "Aborting..."
		exit 0
	fi
}

function perform_delete {
    find "$destination_folder" -mindepth 2 -maxdepth 2 -type f -mmin +$min ! -name '.*' -a -name '*.'"$format" -execdir rm -v {} +
}

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":hd:m:f:y" opt; do
    case "$opt" in
	h)
		print_usage
		exit 0
		;;
    d)
        destination_folder=$OPTARG
        ;;
    m)
        min=$OPTARG
        ;;
    f)
        format=$OPTARG
        ;;
	y)
		yes=true
		;;
    :)
        warning "Option -$OPTARG requires an argument."
        exit 1
        ;;
    \?)
        warning "${BOLD}-$OPTARG${NORMAL} is not a valid argument."
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z "$destination_folder" ]; then
    error "you must set a destination folder with ${BOLD}-d destination_folder${NORMAL}"
	print_usage
	exit 1
fi

print_status
if [ $yes = true ]; then
	yes | confirm
else
	confirm
fi
perform_delete
