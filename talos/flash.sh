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
# curl -LO https://github.com/siderolabs/talos/releases/download/v1.3.7/metal-rpi_4-arm64.img.xz
# xz -d metal-rpi_4-arm64.img.xz
# sudo dd if=metal-rpi_4-arm64.img of=/dev/mmcblk0 conv=fsync bs=4M

# Define variables
IMG_URL="https://github.com/siderolabs/talos/releases/download/v1.3.7/metal-rpi_generic-arm64.img.xz"
TMP_DIR="$(dirname $0)/tmp"
IMG_PATH="$TMP_DIR/talos.img.xz"
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

# Make sure the tmp directory exists
mkdir -p $TMP_DIR

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Only download the img if it doesn't exist
if [[ ! -f $IMG_PATH ]]; then
    echo "Downloading Talos IMG..."
    curl -L -o $IMG_PATH $IMG_URL
    # Verify the download
    if [[ $? -ne 0 ]]; then
        echo "Failed to download IMG"
        exit 1
    fi
    echo "IMG downloaded successfully"

    # Uncompress the img
    echo "Uncompressing IMG..."
    xz -d $IMG_PATH
else
    echo "IMG found, skipping download"
fi

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

# Write IMG to device
echo "Writing IMG to $DEVICE..."
dd if=${IMG_PATH%.xz} of=$DEVICE bs=4M status=progress oflag=sync

# Verify the write
if [[ $? -ne 0 ]]; then
    echo "Failed to write IMG to device"
    exit 1
fi

# Unmount the device
umount $DEVICE

echo "IMG written to $DEVICE successfully"
