#! /bin/bash

#----------------------------------------------------------#
#Setup environments needed
sudo systemctl stop apparmor
sudo systemctl disable apparmor
swapoff -a

#Install CRI Proxy
wget https://github.com/Mirantis/criproxy/releases/download/v0.14.0/criproxy_0.14.0_amd64.deb
dpkg -i criproxy_0.14.0_amd64.deb


systemctl stop kubelet
systemctl daemon-reload
systemctl enable criproxy dockershim
systemctl start criproxy dockershim
systemctl start kubelet

#Virtlet Installation
kubectl label node ubuntu extraRuntime=virtlet

git clone https://github.com/Mirantis/virtlet.git

kubectl create configmap -n kube-system virtlet-image-translations --from-file ./virtlet/deploy/images.yaml

curl -SL -o virtletctl https://github.com/Mirantis/virtlet/releases/download/v1.5.1/virtletctl

chmod +x virtletctl

kubectl create configmap -n kube-system virtlet-config --from-literal=sriov_support=true

kubectl apply -f ./le-intel/virtlet/deploy/images/virtlet-daemonset.yaml

