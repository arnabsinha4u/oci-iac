#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f hello-world-ingress.yaml
echo "Waiting for external IP of ingress and LB"
sleep 60
kubectl apply -f ingress.yaml
kubectl get svc --all-namespaces
kubectl get svc -n ingress-nginx
kubectl get po