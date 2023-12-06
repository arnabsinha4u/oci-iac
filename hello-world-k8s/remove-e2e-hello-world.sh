#!/bin/bash

#Remove Ingress Controller configuration
kubectl delete -f ingress.yaml

#Remove Hello World app and Service
kubectl delete -f hello-world-ingress.yaml

#Remove Ingress Controller
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml