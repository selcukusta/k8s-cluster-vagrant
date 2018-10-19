#!/bin/sh

echo "apiserver address $1"
echo "join token $2"
echo "kubcfg file name $3"

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $1 --token $2 

mkdir -p $HOME/.kube
sudo cp -rf /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml

cp -rf $HOME/.kube/config /vagrant/$3