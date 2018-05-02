 declare -A cameras=(
	["cancellone"]="192.168.0.91"
	["strada"]="192.168.0.92"
	["bagno azzurro"]="192.168.0.93"
	["terrazzo"]="192.168.0.94"
	["garage"]="192.168.0.95"
	["bagno rosa"]="192.168.0.96"
	["ingresso"]="192.168.0.97"
	["salone"]="192.168.0.98"
)

segment_start_number=0

# A POSIX variable
OPTIND=1    # Reset in case getopts has been used previously in the shell.

while getopts ":s:" opt; do
    case "$opt" in
    s)
        segment_start_number=$OPTARG
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

for name in "${!cameras[@]}"
do
	./script.sh -q -t 900 -s $segment_start_number -c -d "../$name" "${cameras[${name}]}" &
done

sleep 1