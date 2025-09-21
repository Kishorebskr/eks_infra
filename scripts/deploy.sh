#!/usr/bin/env bash
set -euo pipefail

AWS_REGION="us-east-1"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="techchallenge/test-app"
ECR_URI="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:latest"

echo "[1/5] Ensure ECR repo exists..."
aws ecr create-repository --repository-name "$ECR_REPO" --region "$AWS_REGION" 2>/dev/null || true

echo "[2/5] Build and push Docker image..."
docker build -t "$ECR_URI" ./app
docker push "$ECR_URI"

echo "[3/5] Create namespace if missing..."
kubectl get ns demo >/dev/null 2>&1 || kubectl create ns demo

echo "[4/5] Deploy Kubernetes manifests..."
# Replace placeholder image with actual ECR URI
sed "s|<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/techchallenge/test-app:latest|$ECR_URI|" k8s/deployment.yaml \
  | kubectl apply -f -
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/hpa.yaml

echo "[5/5] Check status..."
kubectl get all -n demo
