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

if [ $1 -gt 0 ]; then
	segment_start_number=$1
fi

for name in "${!cameras[@]}"
do
	./script.sh -q -t 900 -s $segment_start_number -c -d "../$name" "${cameras[${name}]}" &
done

sleep 1