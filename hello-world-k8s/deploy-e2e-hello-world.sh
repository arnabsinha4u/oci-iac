#!/bin/bash

#Deploy Ingress controller Nginx
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml

#Deploy Hello World App and Service
kubectl apply -f hello-world-ingress.yaml

echo "Waiting for external IP of ingress and LB"
sleep 60

#Configure the ingress controller
kubectl apply -f ingress.yaml

#Retrieve deployed details
kubectl get svc --all-namespaces
kubectl get svc -n ingress-nginx
kubectl get po