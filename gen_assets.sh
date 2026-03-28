#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"

DATADIR="${__dir}/assets"


# Check for required dependencies
check_dependencies() {
    command -v go >/dev/null 2>&1 || { echo >&2 "Go is required but it's not installed. Aborting."; exit 1; }
}


# Download data function
download_dat() {
    mkdir -p "$DATADIR"

    # Download geoip.dat
    if [ ! -f "$DATADIR/geoip.dat" ]; then
        echo "Downloading geoip.dat..."
        curl -sL https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat -o "$DATADIR/geoip.dat"
    else
        echo "geoip.dat already exists in $DATADIR, skipping download."
    fi

    # Download geosite.dat
    if [ ! -f "$DATADIR/geosite.dat" ]; then
        echo "Downloading geosite.dat..."
        curl -sL https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat -o "$DATADIR/geosite.dat"
    else
        echo "geosite.dat already exists in $DATADIR, skipping download."
    fi

    # Download geoip-only-cn-private.dat
    if [ ! -f "$DATADIR/geoip-only-cn-private.dat" ]; then
        echo "Downloading geoip-only-cn-private.dat..."
        curl -sL https://raw.githubusercontent.com/Loyalsoldier/geoip/release/geoip-only-cn-private.dat -o "$DATADIR/geoip-only-cn-private.dat"
    else
        echo "geoip-only-cn-private.dat already exists in $DATADIR, skipping download."
    fi
}

# Main execution logic
ACTION="${1:-download}"

check_dependencies

case $ACTION in
    "download") download_dat ;;
    *) echo "Invalid action: $ACTION" ; exit 1 ;;
esac
