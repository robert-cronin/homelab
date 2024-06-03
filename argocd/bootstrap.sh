#!/bin/sh

kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl apply -f "$(dirname $0)/bootstrap.yaml"

# # Log in using the CLI
# password=$(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)
# argocd login localhost:8080 --username admin --password $password