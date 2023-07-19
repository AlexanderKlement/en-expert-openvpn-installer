# OpenVPN Auto Reconnect for Yocto/OpenWRT devices
### Supported Devices: ResIOT x2, Dragino LPS8

This project provides a script that will help to ensure OpenVPN automatically reconnects on Yocto devices when the
network connectivity is lost or the OpenVPN process is not running.

## Prerequisites

- Yocto/OpenWRT device with OpenVPN installed and configured
- Internet access
- openvpn.conf file in /etc/openvpn
- For Dragino devices: Install latest firmware that includes openvpn (tested with:
  lgw-openvpn--build-v5.4.1676269685-20230213-1429)
  from [here](https://www.dragino.com/downloads/index.php?dir=LoRa_Gateway/LPS8/Firmware/Release/)
- For ResIOT devices: Make sure to have the latest official OpenVPN package installed. The Installer does provide
  an Install-Script via ````update_resiot````

## Installation

Follow the below steps to install the OpenVPN auto-reconnect script:

1. Download the latest release (adjust version accordingly):

```bash
curl -LJO https://github.com/AlexanderKlement/en-expert-openvpn-installer/archive/refs/tags/v1.0.0.tar.gz
```

2. Extract the tar file:

```bash
tar -xvf release.tar.gz
```

3. Make the installer script executable:

```bash
chmod +x install.sh
```

4. Execute the installer script:

```bash
./install.sh
```

During the installation process, the script will ask for the type of the device ("dragino" or "resiot").

## How it works

After installation, the script will begin to run in the background (ResIOT: Busy Waiting | Dragino: CronJob).
It will periodically check the status of the OpenVPN process (only ResIOT atm), as well as the network connectivity by
sending a ping to
a specified IP address.

- If the OpenVPN process is not running, it will attempt to restart the service.
- If the ping to the specified IP address fails, it will attempt to refresh the VPN connection.
- If the maximum number of fails (default: 5 or after 5 minutes) is reached, the system will reboot. This is a fallback
  mechanism only to prevent loosing a device entirely and missing too much data.
