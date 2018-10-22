#!/bin/sh

echo "apiserver address $1"
echo "join token $2"

echo "join to cluster"
sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token $2 $1:6443

echo "route add"
route add 10.96.0.1 gw $1