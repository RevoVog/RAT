#!/bin/bash
# vRemote.sh
# Usage: ./vRemote.sh <ip>

if [ -z "$1" ]; then
    echo "Usage: $0 <ip>"
    exit 1
fi

IP="$1"
USER="Temp"
PASS="P@ssw0rd123!"

# Make sure sshpass is installed (sudo apt install sshpass)
sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP
