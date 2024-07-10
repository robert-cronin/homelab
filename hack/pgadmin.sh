#!/bin/sh
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

# create it like so:
# kubectl cnpg pgadmin4 -n jueju-db jueju-db --mode desktop

# spin up:
# kubectl rollout status deployment cluster-example-pgadmin4

# access:
kubectl port-forward deployment/jueju-db-pgadmin4 -n jueju-db 8080:80
