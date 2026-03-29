#!/bin/bash

# Bash installation script for Orange Pi

# Update system packages
apt-get update && apt-get upgrade -y

# Install Python3 and Flask dependencies
apt-get install python3 python3-pip -y

# Attempt OPi.GPIO installation
pip3 install OPi.GPIO

# Create /root/pisonet/ directory structure
mkdir -p /root/pisonet/{app,logs}

# Copy application files (assumed to be in the same directory)
cps -R ./app/* /root/pisonet/app/

# Initialize JSON data templates
echo '{"data": []}' > /root/pisonet/data.json

# Set permissions
chown -R root:root /root/pisonet/
chmod -R 755 /root/pisonet/

# Install systemd service
cat << EOF > /etc/systemd/system/pisonet.service
[Unit]
Description=PisoNet Service

[Service]
ExecStart=/usr/bin/python3 /root/pisonet/app/main.py
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start the PisoNet service
systemctl start pisonet.service
systemctl enable pisonet.service

# Log the installation
echo "PisoNet installation completed at $(date)" >> /root/pisonet/install.log
