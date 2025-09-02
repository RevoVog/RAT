# RAT - vRemote

vRemote is a modular Remote Administration Tool (RAT) designed to facilitate secure and automated access to Windows hosts from a Linux machine over a LAN. The goal is to provide powerful remote management capabilities, with ongoing development to support internet-based (outside-LAN) connections via a VPS.

## Project Overview

- **Linux Host → Windows Target:**  
  vRemote operates from a Linux machine to control Windows systems within the same LAN.
- **Temporary User Creation:**  
  Delivers an `install.cmd` to the Windows host, which creates a temporary user with known credentials, enables SSH, disables firewalls, saves scripts to Startup, and then self-deletes.
- **Modular Design:**  
  Easily add new features in the future as separate modules.

## Usage

`vRemote.sh` is the main script to interact with Windows hosts:

```bash
# Normal SSH shell
./vRemote.sh <ip>

# Take screenshot of remote Windows host
./vRemote.sh <ip> -SS

# Send file to remote Windows host
./vRemote.sh <ip> -SEND <file-path-to-send>

# Delete all evidence (kill switch)
./vRemote.sh <ip> -KILL
```

## Features

- **SSH Access:**  
  Start an SSH session with the Windows host.
- **Firewall Control:**  
  Automatically disables Windows firewall for easier remote access.
- **File Transfer:**  
  Send and download files to/from remote Windows hosts.
- **Screenshot:**  
  Capture screenshots remotely (currently partially implemented).
- **Kill Switch:**  
  Deletes all traces and evidence from the remote host.
- **Startup Persistence:**  
  Scripts save themselves to Windows Startup for persistence.
- **Self-Deleting Installer:**  
  `install.cmd` cleans up after setup to reduce evidence.

## Planned Features

- **Internet (WAN) Support:**  
  Fully remote access via a VPS for hosts outside the LAN.
- **Easy Access & UAC Bypass:**  
  Remove the need for user permission and bypass UAC for seamless installation and access.
- **More Modules:**  
  Add additional remote features as needed.

## Security & Permissions

- **User Consent:**  
  Currently, installation asks for user permission once. Plans to remove this for more seamless access.
- **Known Credentials:**  
  Temporary user created with predefined credentials for automation.
- **Firewall Disabled:**  
  Ensures smooth remote operation, but reduces target security.

## Important Notes

- This tool is for educational and legitimate remote administration purposes only.
- Unauthorized access to systems without permission is illegal and strictly prohibited.

## Getting Started

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/RevoVog/RAT.git
    cd RAT
    ```
2. **Deliver `install.cmd` to the target Windows user.**  
   This sets up the temporary user, enables SSH, disables the firewall, and saves the necessary scripts to Startup.
3. **Use `vRemote.sh` from your Linux host to connect and control Windows hosts on your LAN.**

## Contributing

- Modular by design: Easily add new features.
- Pull requests and feature suggestions are welcome!

## License

MIT License (see [LICENSE](LICENSE) for details)

## Contact

For questions, feature requests, or support, open an issue or contact [RevoVog](https://github.com/RevoVog).
