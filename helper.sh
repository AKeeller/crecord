#!/bin/bash
readonly version="v0.4.3"

readonly NORMAL='\033[0m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BOLD='\033[1m'
readonly UNDERLINE='\033[4m'

readonly CONFIG="/etc/crecord.config"

function print_version {
    echo -e ${BOLD}$version${NORMAL}
}

function error {
    echo -e "${RED}Error:${NORMAL} $1" >&2
}

function warning {
    echo -e "${YELLOW}Warning:${NORMAL} $1" >&2
}

function confirm {
	read -p "Continue? [Y/n]: " continue
	if [ -n "$continue" ] && [ "$continue" = "y" -o "$continue" = "Y" ]; then
		echo "Continuing..."
		sleep 2 # user has still time to abort
	else
		echo "Aborting..."
		exit 0
	fi
}

function read_config {
	if [ ! -f "$CONFIG" ]; then
		error "Can't find $CONFIG"
		exit 1
	fi
    xmlstarlet sel -t -v "//config/$1" "$CONFIG"
}
