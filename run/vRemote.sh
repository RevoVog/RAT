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

        # Copy Screenshot.ps1 to Windows home directory
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no Screenshot.ps1 $USER@$IP:~

        # Create a CMD wrapper on the remote host
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "echo powershell -ExecutionPolicy Bypass -File %USERPROFILE%\\Screenshot.ps1 > %USERPROFILE%\\RunScreenshot.cmd"

        # Create scheduled task to run the wrapper
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Create /TN ScreenCap /TR %USERPROFILE%\\RunScreenshot.cmd /SC ONCE /ST 00:00 /RL HIGHEST /F"

        # Run the scheduled task
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Run /TN ScreenCap"

        # Wait for screenshot to be generated
        sleep 5

        # Fetch the screenshot back to Linux
        mkdir -p data
        sshpass -p "$PASS" scp -o StrictHostKeyChecking=no $USER@$IP:~/screenshot.png ./data/

        # Cleanup on Windows
        sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Delete /TN ScreenCap /F & del %USERPROFILE%\\Screenshot.ps1 & del %USERPROFILE%\\RunScreenshot.cmd & del %USERPROFILE%\\screenshot.png"

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
