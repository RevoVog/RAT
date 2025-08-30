@echo off
REM Get the path to the user's Downloads folder
set "downloadFolder=%USERPROFILE%\Downloads"

REM Create testing.txt in Downloads
echo File created successfully > "%downloadFolder%\testing.txt"

REM Delete this script (self delete)
(
    start "" cmd /c del "%~f0"
)
