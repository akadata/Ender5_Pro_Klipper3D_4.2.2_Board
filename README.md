# Ender 5 Pro Klipper Configuration with Sprite SE Direct Drive

This repository contains the Klipper configuration files for an Ender 5 Pro with TMC2209 stepper drivers, a CR-Touch sensor, and a Sprite SE direct drive extruder. This setup is designed to enhance the printing capabilities and precision of the Ender 5 Pro.

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Firewall Setup](#firewall-setup)
- [Additional Resources](#additional-resources)
- [License](#license)

## Introduction

Klipper is a 3D printer firmware that utilizes the processing power of a single-board computer (such as a Raspberry Pi) to improve the performance and capabilities of 3D printers. This setup guide will walk you through the process of setting up Klipper on an Ender 5 Pro with a Sprite SE direct drive extruder.

## Prerequisites

Before you begin, ensure you have the following:
- An Ender 5 Pro 3D printer
- A Raspberry Pi 5 4GB/GB Ram with at least 8GB SD card, the faster the SD Card the better. use 128GB if you have one that is fast with go faster stripes or an NVME on PCI-e 1x 
- Internet connection for the Raspberry Pi
- Basic knowledge of using SSH and the command line interface

## Installation

### Step 1: Prepare the Raspberry Pi

1. **Flash Raspberry Pi OS**: Download and flash the latest Raspberry Pi OS (Lite version recommended) onto your SD card using tools like [Raspberry Pi Imager](https://www.raspberrypi.org/software/) or [Balena Etcher](https://www.balena.io/etcher/).

2. **Enable SSH**: After flashing the SD card, create an empty file named `ssh` (no extension) in the root of the SD card to enable SSH on boot.

3. **Connect to Wi-Fi**: Create a file named `wpa_supplicant.conf` in the root of the SD card with the following content, adjusting for your network:
    ```plaintext
    country=GB
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1

    network={
        ssid="YourNetworkSSID"
        psk="YourNetworkPassword"
        key_mgmt=WPA-PSK
    }
    ```

### Step 2: Set Up the Raspberry Pi

1. **Insert the SD card** into the Raspberry Pi and power it on.

2. **SSH into the Raspberry Pi**:
    ```bash
    ssh pi@<your-raspberry-pi-ip>
    # Default password is 'raspberry'
    ```

3. **Update and Upgrade the System**:
    ```bash
    sudo apt update
    sudo apt upgrade -y
    ```

4. **Check Debian Version**:
    ```bash
    cat /etc/debian_version
    # Expected output: 12.5
    ```

### Step 3: Install Klipper, Moonraker, and Mainsail using KIAUH

1. **Clone KIAUH Repository**:
    ```bash
    git clone https://github.com/th33xitus/kiauh.git
    cd kiauh
    ./kiauh.sh
    ```

2. **Install Klipper, Moonraker, and Mainsail**:
    - Run the KIAUH script and follow the prompts to install Klipper, Moonraker, and Mainsail.

### Step 4: Configure Klipper

1. **Flash the MCU Firmware**:
    - Use KIAUH to flash the Klipper firmware to the Ender 5 Pro's mainboard (usually a Creality V4.2.2 or V4.2.7). Follow the detailed instructions provided by KIAUH.

2. **Upload Configuration Files**:
    - Clone this repository and copy the provided configuration files to your Klipper configuration directory (typically `~/printer_data/config`):
      ```bash
      git clone <your-repo-url>
      cd <your-repo>
      cp -r * ~/printer_data/config
      ```

3. **Restart Klipper**:
    ```bash
    sudo service klipper restart
    ```

### Step 5: Calibrate and Test

1. **Access Mainsail**:
    - Open a web browser and navigate to `http://<your-raspberry-pi-ip>` to access the Mainsail web interface.

2. **Calibrate CR-Touch**:
    - Follow the calibration procedures for the CR-Touch sensor and bed mesh leveling as per Klipper documentation.

3. **Test the Printer**:
    - Perform initial test prints to verify everything is working correctly.

## Firewall Setup

To secure your Raspberry Pi, especially if it may be exposed to a public IP, you can set up a firewall. Use the `firewall.sh` script included in this repository to configure iptables.

### Firewall Script

The `firewall.sh` script configures iptables to allow traffic only from specific IP ranges and drop all other incoming traffic.
