sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "echo powershell -ExecutionPolicy Bypass -File ^%USERPROFILE^%\\Screenshot.ps1 > RunScreenshot.cmd"
sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Create /TN ScreenCap /TR %USERPROFILE%\\RunScreenshot.cmd /SC ONCE /ST 00:00 /RL HIGHEST /F"
sshpass -p "$PASS" ssh -o StrictHostKeyChecking=no $USER@$IP "schtasks /Run /TN ScreenCap"
