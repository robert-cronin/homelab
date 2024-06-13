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

set -o errexit

TUNNEL_NAME="robertcronincom"
NAMESPACE="robertcronincom"
SECRET_NAME="tunnel-credentials"
DNS_NAMES=("robertcronin.com" "*.robertcronin.com")

# Prompt for certainty
read -p "Are you sure you want to continue? (yes/no): " CONFIRM
if [[ $CONFIRM != "yes" ]]; then
    echo "Operation cancelled"
    exit 1
fi

# Login
cloudflared tunnel login

# Create tunnel
FILE_PATH=$(cloudflared tunnel create $TUNNEL_NAME | grep -oP 'Tunnel credentials written to \K.*(?=\. cloudflared)')

# Delete secret in k8s
kubectl delete secret $SECRET_NAME -n $NAMESPACE

# Create secret in k8s
kubectl create secret generic $SECRET_NAME --from-file=credentials.json=$FILE_PATH -n $NAMESPACE

# Associate Tunnel with a DNS record
for DNS_NAME in "${DNS_NAMES[@]}"; do
    cloudflared tunnel route dns $TUNNEL_NAME $DNS_NAME
done
