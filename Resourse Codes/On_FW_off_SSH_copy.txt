@echo off
echo ==============================
echo Stopping OpenSSH Server...
echo ==============================

REM Stop SSH service
sc stop sshd

REM Disable auto-start (optional)
sc config sshd start=disabled

echo OpenSSH Server has been stopped.
pause


REM ==============================
REM Re-enable Windows Firewall
REM ==============================
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on

echo.
echo SSH sessions closed and firewall re-enabled.
pause
