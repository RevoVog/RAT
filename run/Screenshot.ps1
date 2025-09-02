# Screenshot.ps1
$scrPath = "$env:USERPROFILE\screenshot.png"

# Task name for temporary execution
$taskName = "TempScreenshotTask"

# Create a temporary task that runs in interactive user session
schtasks /Create /TN $taskName /TR "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command ^
    Add-Type -AssemblyName System.Windows.Forms; ^
    Add-Type -AssemblyName System.Drawing; ^
    \$bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; ^
    \$bmp = New-Object Drawing.Bitmap \$bounds.Width, \$bounds.Height; ^
    \$graphics = [System.Drawing.Graphics]::FromImage(\$bmp); ^
    \$graphics.CopyFromScreen(\$bounds.Location, [System.Drawing.Point]::Empty, \$bounds.Size); ^
    \$bmp.Save('$scrPath',[System.Drawing.Imaging.ImageFormat]::Png); ^
    \$graphics.Dispose(); \$bmp.Dispose()" /SC ONCE /ST 00:00 /RL HIGHEST /F > $null

# Run it immediately
schtasks /Run /TN $taskName > $null

# Wait a little for screenshot to complete
Start-Sleep -Seconds 3

# Delete task
schtasks /Delete /TN $taskName /F > $null
