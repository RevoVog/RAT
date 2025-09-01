@echo off
REM ==============================
REM Disable Windows Firewall (requires admin)
REM ==============================
echo Disabling Windows Firewall...
netsh advfirewall set allprofiles state off

REM ==============================
REM SSH connection
REM ==============================
set /p HOST="Enter SSH Host (IP or hostname): "
set /p USER="Enter SSH Username: "

echo.
echo Starting SSH connection to %USER%@%HOST% ...
ssh %USER%@%HOST%
