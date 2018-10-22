#!/bin/sh

echo "apiserver address $1"
echo "join token $2"
echo "kubcfg file name $3"

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $1 --token $2 

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "apply Flannel CNI"
sudo kubectl apply -f /vagrant/scripts/master-config/kube-flannel.yml
echo "apply Nginx ingress mandatory"
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
echo "create Nginx service"
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
echo "install MetalLB"
sudo kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml

sudo cp -rf $HOME/.kube/config /vagrant/$3