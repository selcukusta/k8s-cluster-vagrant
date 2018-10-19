#!/bin/sh

echo "apiserver address $1"
echo "join token $2"

kubeadm join --discovery-token-unsafe-skip-ca-verification --token $2 $1:6443

route add 10.96.0.1 gw $1