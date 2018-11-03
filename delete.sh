#!/bin/bash
destination_folder=""
readonly min_default=1440
min=$min_default  # delete files older than $min minutes
format="mp4"
yes=false

if [ ! -f `dirname $0`/helper.sh ]; then
	echo "helper.sh not found" >&2
	exit 1
fi

source `dirname $0`/helper.sh

if [ ! -f /etc/crecord.config ]; then
	echo "Can't find /etc/crecord.config"
	exit 1
fi

source /etc/crecord.config

function print_usage {
    echo -e "Usage: `basename $0` [options]
     options:
      ${BOLD}-h, --help${NORMAL}\t\thelp
      ${BOLD}-d destination_folder${NORMAL}\tset root folder of records
      ${BOLD}-m min${NORMAL}\t\t\tdelete files older than min (default: $min_default)
      ${BOLD}-f format${NORMAL}\t\t\tdelete files with extension ${BOLD}format${NORMAL}
      ${BOLD}-y${NORMAL}\t\t\tsay yes to all"
}

function print_status {
    echo -e "${GREEN}$destination_folder${NORMAL}, files older than ${GREEN}$min${NORMAL} minutes in ${GREEN}$format${NORMAL} format"
}

function perform_delete {
    find "$destination_folder" -mindepth 2 -maxdepth 2 -type f -mmin +$min ! -name '.*' -a -name '*.'"$format" -execdir rm -v {} +
}

# transform long options in short options
for arg in "$@"; do
    shift
    case "$arg" in
        "--help")     set -- "$@" "-h" ;;
        "--"*)        error "${BOLD}$arg${NORMAL} is not a valid argument."; exit 1 ;;
        *)            set -- "$@" "$arg"
    esac
done

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
    error "you must set a destination folder with ${BOLD}-d destination_folder${NORMAL} or a default one in /etc/crecord.config"
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
