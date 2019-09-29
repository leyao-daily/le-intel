#! /bin/bash

wget https://dl.google.com/go/go1.13.linux-amd64.tar.gz

tar -zxvf go1.13.linux-amd64.tar.gz

sudo chown -R root:root ./go
sudo mv go /usr/local

sed -i '$a export GOPATH=$HOME/work' .profile
sed -i '$a export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' .profile

source ~/.profile
