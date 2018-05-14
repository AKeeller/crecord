#!/bin/bash
ip="0.0.0.0"
port=554
format=mp4
segment_time=300                # Set segment duration
segment_start_number=0          # Set the sequence number of the first segment
auto_ssn=true                   # Enable auto segment start number
destination_folder="."          # Set output folder
create_destination_folder=false
loglevel="info"                 # Set logging level and flags used by the ffmpeg library
logging=false                   # Set if should log to file
path=""                         # Set RTSP path
loop=false

if [ ! -f `dirname $0`/helper.sh ]; then
	echo "helper.sh not found" >&2
	exit 1
fi

source `dirname $0`/helper.sh

function print_usage {
    echo -e "Usage: `basename $0` [options] ip_address
     options:
      ${BOLD}-h${NORMAL}\t\t\thelp
      ${BOLD}-t segment_time${NORMAL}\t\trecord lengths in seconds
      ${BOLD}-p port${NORMAL}\t\t\tset port number
      ${BOLD}-d destination_folder${NORMAL}\tset destination folder for records
      ${BOLD}-c${NORMAL}\t\t\tcreate destination folder if does not already exist
      ${BOLD}-l${NORMAL}\t\t\tenable logging to file (log.txt)
      ${BOLD}-s segment_start_number${NORMAL}\tset the sequence number of the first segment
      ${BOLD}-P path${NORMAL}\t\t\tset RTSP path
      ${BOLD}-L${NORMAL}\t\t\tenable loop execution
      ${BOLD}-q${NORMAL}\t\t\tquiet"
}

function print_status {
    echo -e "${GREEN}$ip${NORMAL}:${GREEN}$port${NORMAL}/${GREEN}$path${NORMAL} as ${GREEN}$format${NORMAL} in chunks of ${GREEN}$segment_time${NORMAL} seconds and counting from [${GREEN}$segment_start_number${NORMAL}], output to ${GREEN}$destination_folder${NORMAL}"
}

function start_recording {
    ffmpeg -i rtsp://$ip:$port/$path -rtsp_transport tcp -c:v copy -timestamp now -map 0:0 -f stream_segment -reset_timestamps 1 -segment_time $segment_time -segment_format $format -segment_start_number $segment_start_number -segment_atclocktime 1 -loglevel $loglevel "$destination_folder/$ip [%04d].$format"
}

# auto segment_start_number
# look for the latest outputted file
function f_auto_ssn {
    highest=-1
    for file in "$1"/*.mp4
    do
        [ -f "$file" ] || continue # skip if file doesn't exist
        raw_file_number=$(echo "$file" | awk -F'[\[|\]]' '{print $2}')
        file_number=$(expr "$raw_file_number")
        if [ $highest -lt $file_number ]; then
            highest=$file_number
        fi
    done
	echo $(expr $highest + 1)
}

if [ "$1" = "--help" ]; then
    print_usage
    exit 0
fi

if [ "$1" = "--version" ]; then
    print_version
    exit 0
fi

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":hv?qt:p:d:cls:P:L" opt; do
    case "$opt" in
    h)
        print_usage
        exit 0
        ;;
    v)
        print_version
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
    l)
        logging=true
        ;;
    s)
		segment_start_number=$OPTARG
		auto_ssn=false
        ;;
    P)
		path=$OPTARG
		;;
    L)
		loop=true
		;;
    :)
        error "Option -$OPTARG requires an argument."
        exit 1
        ;;
    \?)
        error "${BOLD}-$OPTARG${NORMAL} is not a valid argument."
        exit 1
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift

if [ -z "$1" ]; then
    error "IP address required"
    print_usage
    exit 1
fi

if [ $create_destination_folder = true -a ! -d "$destination_folder" ]; then
    mkdir "$destination_folder"
fi

if [ $auto_ssn = true ]; then
	segment_start_number=$(f_auto_ssn "$destination_folder")
fi

ip=$1

print_status

if [ $loglevel = "quiet" -a $logging = true ]; then
    warning "you have enabled both logging to file and quiet mode."
fi

if [ $loop = true -a $auto_ssn = false ]; then
	warning "you have enabled loop mode, but not auto segment_start_number; this may lead to the overwrite of existing recordings."
fi

while
    if [ $logging = true ]; then
	start_recording &>> "$destination_folder/log.txt"
    else
    	start_recording
    fi

    [ $loop = true ]

do
	if [ $auto_ssn = true ]; then
		segment_start_number=$(f_auto_ssn "$destination_folder")
	fi
done
