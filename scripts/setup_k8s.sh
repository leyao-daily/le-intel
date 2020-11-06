#! /bin/bash

#You can define the Kubernetes Version here
VERSION=1.19.3

#Prepare
swapoff -a
systemctl status apparmor.service
systemctl disable apparmor.service

#-------------------------------------------------------------#
#Docker Installation

##Remove old version
sudo apt-get remove docker docker-engine docker.io containerd runc

##setup apt environments
sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

##add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

##set up the stable repository
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

##Installation
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#-------------------------------------------------------------#
#Kubernetes Installation

##installing kubeadm, kubelet and kubectl
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet=${VERSION}-00 kubeadm=${VERSION}-00 kubectl=${VERSION}-00
apt-mark hold kubelet kubeadm kubectl

##restart kubelet
systemctl daemon-reload
systemctl restart kubelet

##create master node
kubeadm init --pod-network-cidr 10.233.64.0/18  --kubernetes-version=v${VERSION}

##configure env
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

#Kubectl completion bash
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

##pod network add-on flannel
#wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
#kubectl apply -f kube-flannel.yml

##Pod network with cni-proxy multus and calico as default network
kubectl apply -f ../network/calico/calico.yaml
kubectl apply -f ../network/calico/multus-daemonset.yaml

##control plane node isolation
kubectl taint nodes --all node-role.kubernetes.io/master-
