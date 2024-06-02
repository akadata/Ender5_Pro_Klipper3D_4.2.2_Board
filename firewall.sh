#!/bin/bash

# Define network variables
LOCALNET="192.168.0.0/24"
OTHERNET="172.31.31.0/24"

# Define service ports
KLIPPER_PORT=7125        # Port for Klipper service
MAINSIAL_PORT=80         # Port for Mainsail service (HTTP)
MAINSIAL_PORT_ALT=443    # Port for Mainsail service (HTTPS)
OCTOPRINT_PORT=5000      # Port for OctoPrint service
WEBCAM_PORT=8080         # Port for webcam service
SSH_PORT=22              # Port for SSH access

# Clear any existing rules
# Flush all rules and delete user-defined chains in all tables
iptables -F               # Flush all rules in the filter table
iptables -X               # Delete all user-defined chains in the filter table
iptables -t nat -F        # Flush all rules in the nat table
iptables -t nat -X        # Delete all user-defined chains in the nat table
iptables -t mangle -F     # Flush all rules in the mangle table
iptables -t mangle -X     # Delete all user-defined chains in the mangle table
iptables -t raw -F        # Flush all rules in the raw table
iptables -t raw -X        # Delete all user-defined chains in the raw table

# Set default policies
# Drop all incoming and forward traffic, allow outgoing traffic
iptables -P INPUT DROP    # Set default policy for INPUT chain to DROP
iptables -P FORWARD DROP  # Set default policy for FORWARD chain to DROP
iptables -P OUTPUT ACCEPT # Set default policy for OUTPUT chain to ACCEPT

# Allow loopback interface (lo)
iptables -A INPUT -i lo -j ACCEPT   # Allow all traffic on loopback interface
iptables -A OUTPUT -o lo -j ACCEPT  # Allow outgoing traffic on loopback interface

# Allow incoming traffic from specific networks
iptables -A INPUT -s ${LOCALNET} -j ACCEPT  # Allow traffic from local network
iptables -A INPUT -s ${OTHERNET} -j ACCEPT  # Allow traffic from other network

# Allow traffic related to established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# Allow packets that are part of an existing connection or related to an established connection

# Allow incoming SSH
iptables -A INPUT -p tcp --dport $SSH_PORT -j ACCEPT  # Allow SSH traffic

# Allow incoming traffic for Klipper
iptables -A INPUT -p tcp --dport $KLIPPER_PORT -j ACCEPT  # Allow Klipper traffic

# Allow incoming traffic for Mainsail
iptables -A INPUT -p tcp --dport $MAINSIAL_PORT -j ACCEPT      # Allow Mainsail HTTP traffic
iptables -A INPUT -p tcp --dport $MAINSIAL_PORT_ALT -j ACCEPT  # Allow Mainsail HTTPS traffic

# Allow incoming traffic for OctoPrint
iptables -A INPUT -p tcp --dport $OCTOPRINT_PORT -j ACCEPT  # Allow OctoPrint traffic

# Allow incoming traffic for Webcam
iptables -A INPUT -p tcp --dport $WEBCAM_PORT -j ACCEPT  # Allow webcam traffic

# Allow USB traffic (assuming USB network interfaces)
# Note: These rules allow traffic from USB network interfaces usb0 and usb1
# If your USB devices do not create network interfaces, additional steps may be needed
iptables -A INPUT -i usb0 -j ACCEPT  # Allow traffic from USB network interface usb0
iptables -A INPUT -i usb1 -j ACCEPT  # Allow traffic from USB network interface usb1

# Allow ICMP (ping)
iptables -A INPUT -p icmp -j ACCEPT  # Allow ICMP (ping) traffic

# Log dropped packets (optional)
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTABLES DROPPED: " --log-level 4
# Log dropped packets at a rate of 5 per minute to avoid log flooding

# Save the iptables rules
iptables-save > /etc/iptables/rules.v4  # Save the current iptables rules to a file

# Inform user
echo "iptables configuration updated and saved."  # Notify the user that the configuration is updated
