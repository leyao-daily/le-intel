#! /bin/bash

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
sudo apt-get install \
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
sudo apt-get install docker-ce docker-ce-cli containerd.io

#-------------------------------------------------------------#
#Kubernetes Installation

##installing kubeadm, kubelet and kubectl
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

##restart kubelet
systemctl daemon-reload
systemctl restart kubelet

##create master node
kubeadm init --pod-network-cidr 192.168.64.0/20 --kubernetes-version=v1.15.3

##configure env
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf

##pod network add-on
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f kube-flannel.yml

##control plane node isolation
kubectl taint nodes --all node-role.kubernetes.io/master-
