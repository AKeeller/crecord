#!/bin/bash
ip="0.0.0.0"
port=554
format=mp4
segment_time=300
destination_folder="."
create_destination_folder=false
loglevel="info"

readonly NORMAL='\033[0m'
readonly GREEN='\033[0;32m'
readonly BOLD='\033[1m'

function show_usage {
    echo -e "Usage: `basename $0` [options] ip_address
     options:
      ${BOLD}-h${NORMAL}\t\t\thelp
      ${BOLD}-t segment_time${NORMAL}\t\trecord lengths in seconds
      ${BOLD}-p port${NORMAL}\t\t\tsets port number
      ${BOLD}-d destination_folder${NORMAL}\tsets destination folder for records
      ${BOLD}-c${NORMAL}\t\t\tcreate destination folder if does not already exist
      ${BOLD}-q${NORMAL}\t\t\tquiet"
}

function now {
    date +"%Y%m_%d-%H%M"
}

function start_recording {
    ffmpeg -i rtsp://$ip:$port -rtsp_transport tcp -c:v copy -timestamp now -map 0:0 -f stream_segment -reset_timestamps 1 -segment_time $segment_time -segment_format $format -loglevel $loglevel "$destination_folder/$ip [%04d].$format"
}

function print_info {
    echo -e "${GREEN}$ip${NORMAL}:${GREEN}$port${NORMAL} as ${GREEN}$format${NORMAL} in chunks of ${GREEN}$segment_time${NORMAL} seconds, output to ${GREEN}$destination_folder${NORMAL}"
}

if [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":h?qt:p:d:c" opt; do
    case "$opt" in
    h)
        show_usage
        exit 0
        ;;
    q)
        loglevel="quiet"
        ;;
    t)
        segment_time=$OPTARG
        ;;
    p)
	    port=$OPTARG
	    ;;
    d)
        destination_folder=$OPTARG
        ;;
    c)
        create_destination_folder=true
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    \?)
        echo -e "${BOLD}-$OPTARG${NORMAL} is not a valid argument." >&2
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z "$1" ]; then
    echo "IP address required"
    show_usage
    exit 1
fi

if [ $create_destination_folder = true -a ! -d "$destination_folder" ]; then
    mkdir "$destination_folder"
fi

ip=$1

print_info
start_recording