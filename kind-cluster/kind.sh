#!/bin/bash
set -e

# Update the system
yum update -y

# Docker
yum install docker -y
systemctl start docker
systemctl status docker

# Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
kubectl version --client

# Kind 
# Docs : https://kind.sigs.k8s.io/docs/user/quick-start/
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.30.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version

# kind create cluster 
# kind create cluster --name my-cluster
# kind create cluster --config kind-config.yal --name my-cluster 
