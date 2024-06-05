#!/bin/bash

# Copyright 2024 Robert Cronin
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# from website:
# curl -Lo rpi-boot-eeprom-recovery.zip https://github.com/raspberrypi/rpi-eeprom/releases/download/v2021.04.29-138a1/rpi-boot-eeprom-recovery-2021-04-29-vl805-000138a1.zip
# sudo mkfs.fat -I /dev/mmcblk0
# sudo mount /dev/mmcblk0p1 /mnt
# sudo bsdtar rpi-boot-eeprom-recovery.zip -C /mnt

# Define variables
IMG_URL="https://github.com/raspberrypi/rpi-eeprom/releases/download/v2021.04.29-138a1/rpi-boot-eeprom-recovery-2021-04-29-vl805-000138a1.zip"
TMP_DIR=$(mktemp -d)
IMG_PATH="$TMP_DIR/eeprom.zip"
DEVICE=$1

function usage {
    echo "Usage: $0 DEVICE"
    exit 1
}
# Check if DEVICE is set
if [[ -z $DEVICE ]]; then
    echo "DEVICE is not set"
    usage
fi

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Download the img
echo "Downloading EEPROM ZIP..."
curl -L -o $IMG_PATH $IMG_URL

# Verify the download
if [[ $? -ne 0 ]]; then
    echo "Failed to download EEPROM"
    exit 1
fi

echo "EEPROM downloaded successfully"

# Confirm device path
echo "WARNING: This will overwrite all data on $DEVICE"
read -p "Are you sure you want to continue? (yes/no): " CONFIRM
if [[ $CONFIRM != "yes" ]]; then
    echo "Operation cancelled"
    exit 1
fi

# Unmount just in case
umount $DEVICE 2>/dev/null

# Create a new FAT filesystem
sudo mkfs.fat -I $DEVICE

# Mount the device
sudo mount $DEVICE /mnt

# Write EEPROM to device
echo "Writing EEPROM to $DEVICE..."
sudo bsdtar -C /mnt -xvf eeprom.zip

# Verify the write
if [[ $? -ne 0 ]]; then
    echo "Failed to write EEPROM to device"
    exit 1
fi

echo "EEPROM written successfully"
