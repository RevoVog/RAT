<#
.SYNOPSIS
  Creates Temp user, installs OpenSSH Server, opens firewall for SSH.
  Also disables Windows Firewall and Windows Defender.
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
$cap = Get-WindowsCapability -Online | Where-Object Name -Like 'OpenSSH.Server*'
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

Write-Host "`n[4] Disabling Windows Firewall (all profiles)..." -ForegroundColor Cyan
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "  → Firewall disabled" -ForegroundColor Green

Write-Host "`n[5] Disabling Windows Defender (real-time protection)..." -ForegroundColor Cyan
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableIOAVProtection $true
Write-Host "  → Windows Defender real-time protection disabled" -ForegroundColor Green

# Optional: Try to disable Windows Defender service (may require reboot)
Try {
    Stop-Service -Name WinDefend -Force -ErrorAction SilentlyContinue
    Set-Service -Name WinDefend -StartupType Disabled -ErrorAction SilentlyContinue
    Write-Host "  → Attempted to disable Windows Defender service" -ForegroundColor Yellow
} Catch {}

Write-Host "`n=== Setup complete! ===" -ForegroundColor Magenta
Write-Host "You can now SSH in from Linux:" -ForegroundColor Magenta
Write-Host "  ssh Temp@$(Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.IPAddress -ne '127.0.0.1'} | Select-Object -ExpandProperty IPAddress -First 1)" -ForegroundColor Magenta
Write-Host "Password: P@ssw0rd123!" -ForegroundColor Magenta

