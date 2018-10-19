#!/bin/sh

echo "apiserver address $1"
echo "join token $2"
echo "kubcfg file name $3"

# weave
sudo kubeadm init --apiserver-advertise-address $1 --token $2

mkdir -p $HOME/.kube
sudo cp -rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECTL_VERSION=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$KUBECTL_VERSION" 

cp -rf $HOME/.kube/config /vagrant/$3