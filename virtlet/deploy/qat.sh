#!/bin/bash

cd
wget https://packagecloud.io/install/repositories/fdio/release/script.deb.sh
chmod +x ./script.deb.sh

./script.deb.sh

cp /usr/bin/python3 /usr/bin/python
apt install -y vpp
apt install -y vpp-plugin-dpdk
apt install -y make gcc libnuma-dev

cd /opt
git clone http://dpdk.org/git/dpdk
cd dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc/
export DESTDIR=/opt/dpdk
export RTE_SDK=/opt/dpdk
make install T=x86_64-native-linux-gcc
