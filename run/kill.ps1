# Delete startup files
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\setup-ssh-temp.bat" -Force -ErrorAction SilentlyContinue
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\setup-ssh-temp.ps1" -Force -ErrorAction SilentlyContinue

# Self-delete the running script after a short delay
$scriptPath = $MyInvocation.MyCommand.Path
Start-Process -FilePath "cmd.exe" -ArgumentList "/c timeout 2 & del `"$scriptPath`"" -WindowStyle Hidden
