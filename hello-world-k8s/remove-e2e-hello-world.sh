#!/bin/bash

kubectl delete -f ingress.yaml
kubectl delete -f hello-world-ingress.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
