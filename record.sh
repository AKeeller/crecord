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
username=""
password=""
loop=false
filename=""

if [ ! -f `dirname "$0"`/helper.sh ]; then
	echo "helper.sh not found" >&2
	exit 1
fi

source `dirname "$0"`/helper.sh

function print_usage {
    echo -e "Usage: `basename $0` [options] ip_address
     options:
      ${BOLD}-h, --help${NORMAL}\t\thelp
      ${BOLD}-t${NORMAL} ${UNDERLINE}segment_time${NORMAL}\t\trecord lengths in seconds
      ${BOLD}-p${NORMAL} ${UNDERLINE}port${NORMAL}\t\t\tset port number
      ${BOLD}-d${NORMAL} ${UNDERLINE}destination_folder${NORMAL}\tset destination folder for records
      ${BOLD}-c${NORMAL}\t\t\tcreate destination folder if does not already exist
      ${BOLD}-l, --log${NORMAL}\t\t\tenable logging to file (log.txt)
      ${BOLD}-s${NORMAL} ${UNDERLINE}segment_start_number${NORMAL}\tset the sequence number of the first segment
      ${BOLD}-P${NORMAL} ${UNDERLINE}path${NORMAL}\t\t\tset RTSP path
      ${BOLD}-L${NORMAL}\t\t\tenable loop execution
      ${BOLD}-u, --username${NORMAL} ${UNDERLINE}username${NORMAL}\tset username
      ${BOLD}-w, --password${NORMAL} ${UNDERLINE}password${NORMAL}\tset password
      ${BOLD}-f, --filename${NORMAL} ${UNDERLINE}filename${NORMAL}\tset output filename
      ${BOLD}-q${NORMAL}\t\t\tquiet"
}

function print_status {
    echo -e "${GREEN}$ip${NORMAL}:${GREEN}$port${NORMAL}/${GREEN}$path${NORMAL} as ${GREEN}$format${NORMAL} in chunks of ${GREEN}$segment_time${NORMAL} seconds and counting from [${GREEN}$segment_start_number${NORMAL}], output to ${GREEN}$destination_folder${NORMAL}"
}

function start_recording {
    ffmpeg -i rtsp://$username:$password@$ip:$port/$path -rtsp_transport tcp -c:v copy -timestamp now -map 0:0 -f stream_segment -reset_timestamps 1 -segment_time $segment_time -segment_format $format -segment_start_number $segment_start_number -segment_atclocktime 1 -loglevel $loglevel "$destination_folder/$filename [%04d].$format"
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

# transform long options in short options
for arg in "$@"; do
	shift
	case "$arg" in
		"--help")     set -- "$@" "-h" ;;
		"--version")  set -- "$@" "-v" ;;
		"--log")      set -- "$@" "-l" ;;
		"--username") set -- "$@" "-u" ;;
		"--password") set -- "$@" "-w" ;;
		"--filename") set -- "$@" "-f" ;;
		"--"*)        error "${BOLD}$arg${NORMAL} is not a valid argument."; exit 1 ;;
		*)            set -- "$@" "$arg"
	esac
done

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":hv?qt:p:d:cls:P:Lu:w:f:" opt; do
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
        destination_folder="$OPTARG"
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
	path="$OPTARG"
	;;
    L)
	loop=true
	;;
    u)
	username="$OPTARG"
	;;
    w)
	password="$OPTARG"
	;;
    f)
	filename="$OPTARG"
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

command -v ffmpeg >/dev/null 2>&1 || { error "ffmpeg is required but it's not installed. Aborting."; exit 1; }

if [ -z "$1" ]; then
    error "IP address required"
    print_usage
    exit 1
fi

ip="$1"

if [ $create_destination_folder = true -a ! -d "$destination_folder" ]; then
    mkdir "$destination_folder"
fi

[ ! -w "$destination_folder" ] && error "$destination_folder is not writable, aborting." && exit 1 # error if destination folder is not writable

if [ $auto_ssn = true ]; then
	segment_start_number=$(f_auto_ssn "$destination_folder")
fi

if [ -z "$filename" ]; then
	filename="$ip"
fi

print_status

if [ $loglevel = "quiet" -a $logging = true ]; then
    warning "you have enabled both logging to file and quiet mode."
fi

if [ $loop = true -a $auto_ssn = false ]; then
	warning "you have enabled loop mode, but not auto segment_start_number; this may lead to the overwrite of existing recordings."
fi

# while statements; condition; do; statements; done
while
    if [ $logging = true ]; then
	[ ! -e "$destination_folder/log.txt" ] && touch "$destination_folder/log.txt" # check if file exists. If not, create.
	[ ! -w "$destination_folder/log.txt" ] && error "$destination_folder/log.txt is not writable, aborting." && exit 1 # check if log.txt is writable
	start_recording &>> "$destination_folder/log.txt"
    else
    	start_recording
    fi

    [ $loop = true ] # this condition controls the loop

do
	if [ $auto_ssn = true ]; then
		segment_start_number=$(f_auto_ssn "$destination_folder")
	fi
done
