# Disable Windows Firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Write-Host "Windows Firewall has been disabled for all profiles."

# Temporarily disable Windows Defender Real-Time Protection
Set-MpPreference -DisableRealtimeMonitoring $true
Write-Host "Windows Defender Real-Time Protection has been disabled."
