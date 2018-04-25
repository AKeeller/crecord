#!/bin/bash
ip="0.0.0.0"
port=554
format=mp4
segment_time=300
destination_folder="./"
create_destination_folder=false
loglevel="info"

readonly GREEN='\033[0;32m'
readonly NC='\033[0m' # No Color

function show_help {
    echo "Usage: `basename $0` [-h] [-t segment_time] [-p port] [-d destination_folder] [-c] [-q] ip_address"
}

function start_recording {
    ffmpeg -i rtsp://$ip:$port -vcodec copy -map 0:0 -f segment -segment_time $segment_time -segment_format $format -loglevel $loglevel "$destination_folder/ffmpeg_capture-$ip-%03d.$format"
}

function print_info {
    echo -e "${GREEN}$ip${NC} as ${GREEN}$format${NC} in chunks of ${GREEN}$segment_time${NC} seconds"
}

if [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":h?qt:p:d:c" opt; do
    case "$opt" in
    h|\?)
        show_help
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
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z "$1" ]; then
    show_help
    exit 1
fi

if [ $create_destination_folder = true ]; then
    mkdir $destination_folder
fi

ip=$1

print_info
start_recording