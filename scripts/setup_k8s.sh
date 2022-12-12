#! /bin/bash

#You can define the Kubernetes Version here
VERSION=1.25.3

#Prepare
modprobe br_netfilter
sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sysctl -w net.bridge.bridge-nf-call-iptables=1
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
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

##set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

##Installation
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

#-------------------------------------------------------------#
#Kubernetes Installation

##installing kubeadm, kubelet and kubectl
##installing kubeadm, kubelet and kubectl
apt-get update && apt-get install -y apt-transport-https curl ca-certificates
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet=${VERSION}-00 kubeadm=${VERSION}-00 kubectl=${VERSION}-00
apt-mark hold kubelet kubeadm kubectl

##restart kubelet
systemctl daemon-reload
systemctl restart kubelet

##create master node
kubeadm init --pod-network-cidr 10.244.0.0/16  --kubernetes-version=v${VERSION}

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
# kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint node --all node-role.kubernetes.io/control-plane-
