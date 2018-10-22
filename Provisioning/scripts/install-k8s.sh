#!/bin/sh
echo "node IP: $1"

echo "swapoff"
sudo swapoff -a

echo "update fstab so that swap remains disabled after a reboot"
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Docker version for ubuntu/xenial64
export DOCKER_VERSION=18.06.1~ce~3-0~ubuntu

echo "running apt-get update and installing some packages"
sudo apt-get update && sudo apt-get install -yq apt-transport-https \
  linux-image-extra-$(uname -r) \
  linux-image-extra-virtual \
  ca-certificates

echo "add docker apt repository and gpg key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable"

echo "installing docker"
sudo apt-get update && sudo apt-get install -yq docker-ce=$DOCKER_VERSION

echo "add kubernetes apt repository and gpg key"
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository \
  "deb [arch=amd64] http://apt.kubernetes.io \
  kubernetes-$(lsb_release -cs) \
  main"

echo "installing kubeadm and dependencies"
sudo apt-get update && sudo apt-get install -yq \
  kubelet \
  kubeadm \
  kubectl

sudo apt-mark hold kubelet kubeadm kubectl

echo "add --fail-swap-on=false"
sudo sed -i '9s/^/Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false --node-ip='"$1"'"\n/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

echo "reload daemon after kubelet definition is changed"
sudo systemctl daemon-reload
echo "restart kubelet service"
sudo systemctl restart kubelet.service