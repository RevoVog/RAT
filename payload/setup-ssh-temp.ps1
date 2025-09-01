<#
.SYNOPSIS
  Creates Temp user, installs OpenSSH Server, opens firewall for SSH.
#>

Write-Host "`n[1] Ensuring Temp user exists…" -ForegroundColor Cyan
if (-not (Get-LocalUser -Name 'Temp' -ErrorAction SilentlyContinue)) {
    $plain  = 'P@ssw0rd123!'
    $secure = ConvertTo-SecureString $plain -AsPlainText -Force
    New-LocalUser -Name 'Temp' `
      -Password $secure `
      -AccountNeverExpires `
      -PasswordNeverExpires `
      -Description 'Temporary SSH user' | Out-Null
    Add-LocalGroupMember -Group 'Users' -Member 'Temp'
    Write-Host "  → Created user 'Temp' with password: $plain" -ForegroundColor Green
} else {
    Write-Host "  → User 'Temp' already exists" -ForegroundColor Yellow
}

Write-Host "`n[2] Installing or verifying OpenSSH Server…" -ForegroundColor Cyan
$cap = Get-WindowsCapability -Online |
       Where-Object Name -Like 'OpenSSH.Server*'
if ($cap.State -ne 'Installed') {
    Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0'
    Write-Host "  → OpenSSH Server installed" -ForegroundColor Green
} else {
    Write-Host "  → OpenSSH Server already installed" -ForegroundColor Yellow
}

Write-Host "`n[3] Configuring and starting sshd service…" -ForegroundColor Cyan
Set-Service -Name sshd -StartupType Automatic
if ((Get-Service -Name sshd).Status -ne 'Running') {
    Start-Service sshd
    Write-Host "  → sshd service started" -ForegroundColor Green
} else {
    Write-Host "  → sshd service already running" -ForegroundColor Yellow
}

Write-Host "`n[4] Opening firewall for SSH (TCP 22)…" -ForegroundColor Cyan
if (-not (Get-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
      -Name 'OpenSSH-Server-In-TCP' `
      -DisplayName 'OpenSSH SSH Server (TCP-In)' `
      -Protocol TCP `
      -LocalPort 22 `
      -Direction Inbound `
      -Action Allow
    Write-Host "  → Firewall rule created" -ForegroundColor Green
} else {
    Write-Host "  → Firewall rule already exists" -ForegroundColor Yellow
}

Write-Host "`n=== Setup complete! ===" -ForegroundColor Magenta
Write-Host "You can now SSH in from Linux:" -ForegroundColor Magenta
Write-Host "  ssh Temp@$(Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -ne '127.0.0.1'} | Select-Object -ExpandProperty IPAddress -First 1)" -ForegroundColor Magenta
Write-Host "Password: P@ssw0rd123!" -ForegroundColor Magenta
