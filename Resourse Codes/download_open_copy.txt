@echo off
set "downloadFolder=%USERPROFILE%\Downloads"

REM 1. Create testing.txt in Downloads
echo This is a test file. > "%downloadFolder%\testing.txt"

REM 2. Download the image as image.png
powershell -Command "Invoke-WebRequest -Uri 'https://freetestdata.com/wp-content/uploads/2021/09/500kb.png' -OutFile '%downloadFolder%\image.png'"

REM 3. Create open.cmd to open image.png
(
echo @echo off
echo set "downloadFolder=%%USERPROFILE%%\Downloads"
echo start "" "%%downloadFolder%%\image.png"
) > "%downloadFolder%\open.cmd"

REM 4. Self delete
start "" cmd /c del "%~f0"
