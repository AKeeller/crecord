#!/bin/bash
readonly version="v0.3.1"

readonly NORMAL='\033[0m'
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BOLD='\033[1m'

function error {
    echo -e "${RED}Error:${NORMAL} $1" >&2
}

function warning {
    echo -e "${YELLOW}Warning:${NORMAL} $1" >&2
}
