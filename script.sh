#!/bin/bash
IP="0.0.0.0"
port=554
format=mp4
segment_time=300
quiet=false
destination_folder="./"

GREEN='\033[0;32m'
NC='\033[0m' # No Color

function show_help {
    echo "Usage: `basename $0` [-h] [-t segment_time] [-p port] [-d destination_folder] [-q] IP_ADDRESS"
}

function start_recording {
    ffmpeg -i rtsp://$IP:$port -vcodec copy -map 0:0 -f segment -segment_time $segment_time -segment_format $format "$destination_folder/ffmpeg_capture-$IP-%03d.$format"
}

function print_info {
    echo -e "${GREEN}$IP${NC} as ${GREEN}$format${NC} in chunks of ${GREEN}$segment_time${NC} seconds"
}

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

if [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

while getopts ":h?qt:p:d:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    q)
        quiet=true
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

IP=$1

print_info

if [ $quiet = true ]; then
    start_recording &> /dev/null
else
    start_recording
fi
