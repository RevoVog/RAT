@echo off
REM ================================================
REM Elevate to Administrator (one-time UAC prompt)
REM ================================================
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
  echo Requesting elevated privileges…
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

REM ================================================
REM Call the PowerShell provisioning script
REM ================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-ssh-temp.ps1"
pause
