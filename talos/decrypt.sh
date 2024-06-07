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

DEC_DIR="dec"
ENC_DIR="config"

mkdir -p "$ENC_DIR" "$DEC_DIR"

# Decrypt controlplane.yaml
sops -d "$ENC_DIR/controlplane.enc.yaml" > "$DEC_DIR/controlplane.yaml"

# Decrypt worker-pi.yaml
sops -d "$ENC_DIR/worker-pi.enc.yaml" > "$DEC_DIR/worker-pi.yaml"

# Decrypt worker-macmini.yaml
sops -d "$ENC_DIR/worker-macmini.enc.yaml" > "$DEC_DIR/worker-macmini.yaml"

# Decrypt talosconfig.yaml
sops -d "$ENC_DIR/talosconfig.enc.yaml" > "$DEC_DIR/talosconfig.yaml"