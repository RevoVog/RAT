#!/bin/bash
# vRemote.sh
# Usage:
#   ./vRemote.sh <ip>                -> Normal SSH shell
#   ./vRemote.sh <ip> -SS            -> Take screenshot
#   ./vRemote.sh <ip> -KILL          -> Example for more tools later

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
        
    -SEND)
        if [ -z "$3" ]; then
            echo "Usage: $0 <ip> -SEND <local_file_path>"
            exit 1
        fi

        LOCAL_FILE="$3"
        REMOTE_PATH="~"

        echo "[*] Sending $LOCAL_FILE to $IP ..."
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no "$LOCAL_FILE" $USER@$IP:$REMOTE_PATH

        echo "[*] File sent to $IP:$REMOTE_PATH"
        ;;
    
    -KILL)

        TARGET1="C:\Path\To\Your\First\Target.exe" # Add startup location installed files
        TARGET2="C:\Path\To\Your\Second\Target.exe" # Add startup location installed files

        echo "[*] Deleting $TARGET1 on $IP ..."
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "del \"$TARGET1\""
        echo "[*] Deleting $TARGET2 on $IP ..."
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "del \"$TARGET2\""
        ;;
    *)
        # Default: normal SSH shell
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP
        ;;
esac
