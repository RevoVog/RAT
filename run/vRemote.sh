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

        # Create scheduled task to run Screenshot.ps1 as active user
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Create /TN ScreenCap /TR 'powershell -ExecutionPolicy Bypass -File %USERPROFILE%\\Screenshot.ps1' /SC ONCE /ST 00:00 /RL HIGHEST /F"

        # Run the task
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Run /TN ScreenCap"

        # Wait for screenshot
        sleep 5

        # Fetch the screenshot
        mkdir -p data
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no $USER@$IP:~/screenshot.png ./data/

        # Cleanup
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Delete /TN ScreenCap /F; del Screenshot.ps1; del screenshot.png"

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
