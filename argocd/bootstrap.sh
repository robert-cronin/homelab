#!/bin/sh

set -o errexit

kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# # Log in using the CLI
# password=$(argocd admin initial-password -n argocd --as string)
# argocd login localhost:8080 --username admin --password $password