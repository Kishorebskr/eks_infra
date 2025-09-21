#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="techchallenge/test-app"

echo "Deleting Kubernetes resources..."
kubectl delete -n demo -f k8s/hpa.yaml --ignore-not-found
kubectl delete -n demo -f k8s/ingress.yaml --ignore-not-found
kubectl delete -n demo -f k8s/service.yaml --ignore-not-found
kubectl delete -n demo -f k8s/deployment.yaml --ignore-not-found
kubectl delete ns demo --ignore-not-found

echo "Deleting ECR repo..."
aws ecr delete-repository --repository-name "$ECR_REPO" --region "$AWS_REGION" --force || true
