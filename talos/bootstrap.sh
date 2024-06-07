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

# Define variables
CWD=$(dirname $0)
CONFIG_DIR="$CWD/dec"
MACMINI_IP="192.168.86.143"
RPI_4GB_IP="192.168.86.166"
RPI_8GB_IP="192.168.86.167"

mkdir -p "$CONFIG_DIR"

# Make sure you want to continue
read -p "This will overwrite the existing configuration. Are you sure you want to continue? (y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

talosctl gen config "tiesanjiao" "https://$RPI_4GB_IP:6443" \
    --install-disk /dev/mmcblk0 \
    --output-dir "$CONFIG_DIR"

# Rename talosconfig to talosconfig.yaml
mv "$CONFIG_DIR/talosconfig" "$CONFIG_DIR/talosconfig.yaml"

# Move worker.yaml to worker-pi.yaml
mv "$CONFIG_DIR/worker.yaml" "$CONFIG_DIR/worker-pi.yaml"

# Copy worker-pi.yaml to worker-macmini.yaml
cp "$CONFIG_DIR/worker-pi.yaml" "$CONFIG_DIR/worker-macmini.yaml"

# Change the install disk in macmini to /dev/nvme0n1p2
sed -i 's/mmcblk0/nvme0n1p2/g' "$CONFIG_DIR/worker-macmini.yaml"

talosctl --talosconfig="$CONFIG_DIR/talosconfig.yaml" \
    config endpoint $RPI_4GB_IP

talosctl --talosconfig="$CONFIG_DIR/talosconfig.yaml" \
    config node $RPI_8GB_IP $MACMINI_IP

# Merge
talosctl config merge "$CONFIG_DIR/talosconfig.yaml"

# Apply
talosctl apply-config --insecure --nodes $RPI_4GB_IP --file "$CONFIG_DIR/controlplane.yaml"

# Bootstrap
talosctl bootstrap --nodes $RPI_4GB_IP

# Apply config to worker nodes (TODO: include macmini)
talosctl apply-config --insecure --nodes $RPI_8GB_IP --file "$CONFIG_DIR/worker-pi.yaml"
talosctl apply-config --insecure --nodes $MACMINI_IP --file "$CONFIG_DIR/worker-macmini.yaml"