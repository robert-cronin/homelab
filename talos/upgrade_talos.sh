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

IMAGE="ghcr.io/siderolabs/installer:v1.7.4"

# Get IP from argument
NODE_IP=$1

if [[ -z $NODE_IP ]]; then
    echo "Usage: $0 NODE_IP"
    exit 1
fi

talosctl upgrade --nodes $NODE_IP \
    --image $IMAGE
