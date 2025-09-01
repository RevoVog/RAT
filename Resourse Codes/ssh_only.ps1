# Install the OpenSSH Server feature
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start the SSH service
Start-Service sshd

# Make SSH start automatically at boot
Set-Service -Name sshd -StartupType 'Automatic'

# Allow SSH through the Windows Firewall
New-NetFirewallRule -Name sshd -DisplayName "OpenSSH Server" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
