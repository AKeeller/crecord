IPs=( 192.168.0.9{1..8} )

for IP in ${IPs[*]}
do
	./script.sh $IP &> /dev/null &
done
