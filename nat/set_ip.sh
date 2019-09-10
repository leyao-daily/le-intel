#! /bin/bash

iptables -A FORWARD -i eno1 -j ACCEPT

iptables -t nat -A POSTROUTING -s 192.168.222.0/24 -o enx00e04c534458 -j MASQUERADE

iptables-save
