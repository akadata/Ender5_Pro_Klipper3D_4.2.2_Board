#!/bin/bash

localnet=192.168.0.0/24
othernet=172.31.31.0/24
# Clear any existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X
iptables -t raw -F
iptables -t raw -X

# Set default policies to drop all incoming and forward traffic, allow outgoing
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Allow loopback interface (lo)
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Allow incoming traffic from the specific network
iptables -A INPUT -s ${localnet} -j ACCEPT
iptables -A INPUT -s ${othernet} -j ACCEPT

# Allow traffic related to established connections
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Log dropped packets (optional)
iptables -A INPUT -j LOG --log-prefix "IPTABLES DROPPED: " --log-level 4

# Save the iptables rules
iptables-save > /etc/iptables/rules.v4

echo "iptables configuration updated and saved."
