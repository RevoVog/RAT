#!/bin/bash
# vRemote.sh
# Usage:
#   ./vRemote.sh <ip>                -> Normal SSH shell
#   ./vRemote.sh <ip> -SS            -> Take screenshot
#   ./vRemote.sh <ip> -KILL <target> -> Example for more tools later

if [ -z "$1" ]; then
    echo "Usage: $0 <ip> [tool]"
    exit 1
fi

IP="$1"
USER="Temp"
PASS="P@ssw0rd123!"
TOOL="$2"

# Make sure sshpass and scp are installed
command -v sshpass >/dev/null 2>&1 || { echo >&2 "sshpass is required. Install it with: sudo apt install sshpass"; exit 1; }

case "$TOOL" in
    -SS)
        echo "[*] Running Screenshot tool on $IP ..."

        # Copy Screenshot.ps1 to Windows
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no Screenshot.ps1 $USER@$IP:~

        # Run Screenshot.ps1 remotely
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "powershell -ExecutionPolicy Bypass -File Screenshot.ps1"

        # Fetch the screenshot
        mkdir -p data
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no $USER@$IP:~/screenshot.png ./data/

        # Cleanup remote files
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "del Screenshot.ps1; del screenshot.png"

        echo "[*] Screenshot saved to ./data/"
        ;;
    -KILL)
        TARGET="$3"
        if [ -z "$TARGET" ]; then
            echo "Usage: $0 <ip> -KILL <target_file>"
            exit 1
        fi
        echo "[*] Deleting $TARGET on $IP ..."
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "del \"$TARGET\""
        ;;
    *)
        # Default: normal SSH shell
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP
        ;;
esac
