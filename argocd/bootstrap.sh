#!/bin/sh

helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd \
    -n argocd \
    --create-namespace

kubectl apply -f "$(dirname $0)/bootstrap.yaml"
