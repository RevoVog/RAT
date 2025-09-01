@echo off
REM ==============================
REM Disable Windows Firewall (requires admin)
REM ==============================
echo Disabling Windows Firewall...
netsh advfirewall set allprofiles state off

@echo off
echo ==============================
echo Starting OpenSSH Server...
echo ==============================

REM Install OpenSSH Server if not already installed (Windows 10/11)
dism /online /Get-Capabilities | findstr OpenSSH.Server >nul
if %errorlevel% neq 0 (
    echo Installing OpenSSH Server...
    dism /online /Add-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0
)

REM Start the SSH service
sc start sshd

REM Set to start automatically on boot (optional)
sc config sshd start=auto

echo OpenSSH Server is running. You can SSH to this machine now.
pause
