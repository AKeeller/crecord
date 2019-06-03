source `dirname -- "$0"`/helper.sh || exit 1

function xml2csv {
	xmlstarlet sel -t -m "//config/cameras/*" -v "./@name" -o "," -v "./@ip" -o "," -v "./@username" -o "," -v "./@password" -o "," -v "./@rtsp_path" --nl "$1"
}

function csv_parser {
	while IFS=, read -r name ip username password rtsp_path
	do
		/usr/local/bin/crecord.d/record.sh -l -L -t 1800 -c -d "$destination_folder/$name" -P "$rtsp_path" -u "$username" -w "$password" "$ip" &
	done
}

declare -r csv=$(xml2csv "$CONFIG" | xmlstarlet unesc)
declare -r destination_folder=$(read_config "destination_folder")

csv_parser <<< "$csv"
