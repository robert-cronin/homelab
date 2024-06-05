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
CONFIG_DIR="$CWD/config"
# MACMINI_IP="192.168.86.xxx" # TODO: include macmini
RPI_4GB_IP="192.168.86.166"
RPI_8GB_IP="192.168.86.167"

mkdir -p "$CONFIG_DIR"

    # --install-image=ghcr.io/siderolabs/kubelet:v1.29.4 \
talosctl gen config "tiesanjiao" "https://$RPI_4GB_IP:6443" \
    --install-disk /dev/mmcblk0 \
    --output-dir "$CONFIG_DIR"

talosctl --talosconfig="$CONFIG_DIR/talosconfig" \
    config endpoint $RPI_4GB_IP $RPI_8GB_IP

talosctl --talosconfig="$CONFIG_DIR/talosconfig" \
    config node $RPI_4GB_IP

# Merge
talosctl config merge "$CONFIG_DIR/talosconfig"

# Apply
talosctl apply-config --insecure --nodes $RPI_4GB_IP --file "$CONFIG_DIR/controlplane.yaml"

# Bootstrap
talosctl bootstrap --nodes $RPI_4GB_IP

# Apply config to worker nodes (TODO: include macmini)
talosctl apply-config --insecure --nodes $RPI_8GB_IP --file "$CONFIG_DIR/worker.yaml"
# talosctl apply-config --insecure --nodes $RPI_8GB_IP $MACMINI_IP --file "$CONFIG_DIR/worker.yaml"