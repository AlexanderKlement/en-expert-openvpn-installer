#!/bin/bash

# Ask for the type of device
echo "Please enter the type of device (dragino or resiot):"
read DEVICE_TYPE

# Define paths depending on device type
if [ "$DEVICE_TYPE" = "dragino" ]; then
    DAEMON="/usr/sbin/openvpn"
    PID_DIR="/tmp/run"
elif [ "$DEVICE_TYPE" = "resiot" ]; then
    DAEMON="/usr/local/sbin/openvpn"
    PID_DIR="/run"
    curl -s update.resiot.io/extra/openvpn/resiot_gw_x2_x4_x7_update_openvpn_to_2412.sh | bash
else
    echo "Invalid device type. Please enter either 'dragino' or 'resiot'."
    exit 1
fi

# Copy the check_openvpn script
cp check_openvpn /etc/init.d/

# Make the script executable
chmod +x /etc/init.d/check_openvpn

# Modify the script with the correct paths
sed -i "s|DAEMON=.*|DAEMON=$DAEMON|" /etc/init.d/check_openvpn
sed -i "s|PID_DIR=.*|PID_DIR=$PID_DIR|" /etc/init.d/check_openvpn

# Add the script to startup
if [ "$DEVICE_TYPE" = "resiot" ]; then
    update-rc.d check_openvpn defaults
elif [ "$DEVICE_TYPE" = "dragino" ]; then
    ln -s /etc/init.d/check_openvpn /etc/rc.d/
fi

echo "Installation complete."
