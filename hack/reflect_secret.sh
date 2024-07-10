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

# Link it like so: sudo ln -s $PWD/hack/reflect_secret.sh /usr/local/bin/kubectl-reflect
# Or just copy it in there: sudo cp $PWD/hack/reflect_secret.sh /usr/local/bin/kubectl-reflect
# example: kubectl reflect --namespace rabbitmq --target-namespace jueju --secret rabbitmq

# Function to display usage information
usage() {
    echo "Usage: kubectl reflect --namespace <origin-namespace> --target-namespace <target-namespace> --secret <secret-name>"
    exit 1
}

# Parse command line flags
while [[ "$#" -gt 0 ]]; do
    case $1 in
    --namespace)
        ORIGIN_NAMESPACE="$2"
        shift
        ;;
    --target-namespace)
        TARGET_NAMESPACE="$2"
        shift
        ;;
    --secret)
        SECRET_NAME="$2"
        shift
        ;;
    -h | --help) usage ;;
    *)
        echo "Unknown parameter passed: $1"
        usage
        ;;
    esac
    shift
done

# Check if all required arguments are provided
if [ -z "$ORIGIN_NAMESPACE" ] || [ -z "$TARGET_NAMESPACE" ] || [ -z "$SECRET_NAME" ]; then
    usage
fi

# Annotate the secret with the provided annotations
kubectl annotate secret $SECRET_NAME \
    -n $ORIGIN_NAMESPACE \
    reflector.v1.k8s.emberstack.com/reflection-allowed=true \
    reflector.v1.k8s.emberstack.com/reflection-allowed-namespaces=$TARGET_NAMESPACE \
    reflector.v1.k8s.emberstack.com/reflection-auto-enabled=true \
    reflector.v1.k8s.emberstack.com/reflection-auto-namespaces=$TARGET_NAMESPACE

echo "Secret '$SECRET_NAME' in namespace '$ORIGIN_NAMESPACE' has been annotated successfully for reflection to '$TARGET_NAMESPACE'."
