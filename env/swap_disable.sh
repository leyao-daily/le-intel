#!/bin/bash
swapoff -a 
sed -ri 's/.*swap.*/#&/' /etc/fstab
