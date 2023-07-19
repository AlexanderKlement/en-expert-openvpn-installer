#!/bin/bash

# Ask for the type of device
echo "Please enter the type of device (dragino or resiot):"
read DEVICE_TYPE

# Define paths depending on device type
if [ "$DEVICE_TYPE" = "dragino" ]; then
    SCRIPT_DIR="/etc/en-expert"
    # Make sure the script directory exists
    mkdir -p $SCRIPT_DIR
    # Copy the script to the script directory
    cp check_openvpn_dragino.sh $SCRIPT_DIR

    # Check if the cron job already exists
    if crontab -l | grep -q "$SCRIPT_DIR/check_openvpn.sh"; then
      echo "Cron job already exists. Skipping..."
    else
      # Add a cron job to run the script every minute
      (crontab -l 2>/dev/null; echo "* * * * * $SCRIPT_DIR/check_openvpn.sh") | crontab -
      echo "Cron job added."
    fi


elif [ "$DEVICE_TYPE" = "resiot" ]; then
    # Copy the check_openvpn_resiot_service script
    cp check_openvpn_resiot_service /etc/init.d/

    # Make the script executable
    chmod +x /etc/init.d/check_openvpn_resiot_service

    # Add the script to startup
    update-rc.d check_openvpn defaults

elif [ "$DEVICE_TYPE" = "update_resiot" ]; then

    curl -s update.resiot.io/extra/openvpn/resiot_gw_x2_x4_x7_update_openvpn_to_2412.sh | bash

else
    echo "Invalid device type. Please enter either 'dragino' or 'resiot'."
    exit 1
fi

echo "Installation complete."
