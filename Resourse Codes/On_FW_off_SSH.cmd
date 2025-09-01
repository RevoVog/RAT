@echo off
REM ==============================
REM Close SSH session(s)
REM ==============================
echo Closing SSH sessions...
taskkill /IM ssh.exe /F >nul 2>&1

REM ==============================
REM Re-enable Windows Firewall
REM ==============================
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on

echo.
echo SSH sessions closed and firewall re-enabled.
pause
