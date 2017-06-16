#!/bin/bash

#set bond

eth0=
eth1=
mode="activebackup"

hostname=
ip=
prefix=
gateway=

hostnamectl set-hostname $hostname

echo -e "DEVICE=bond0\nTYPE=Bond\nBONDING_MASTER=yes\nONBOOT=yes\nBOOTPROTO=none" > /etc/sysconfig/network-scripts/ifcfg-bond0
echo BONDING_OPTS="mode=$mode miimon=100" >> /etc/sysconfig/network-scripts/ifcfg-bond0
echo -e "IPADDR=$ip\nPREFIX=$prefix\nGATEWAY=$gateway" >> /etc/sysconfig/network-scripts/ifcfg-bond0

echo -e "DEVICE=$eth0\nMASTER=bond0\nTYPE=Ethernet\nBOOTPROTO=none\nONBOOT=yes\nSLAVE=yes\nUSERCTL=yes" > /etc/sysconfig/network-scripts/ifcfg-$eth0
echo -e "DEVICE=$eth1\nMASTER=bond0\nTYPE=Ethernet\nBOOTPROTO=none\nONBOOT=yes\nSLAVE=yes\nUSERCTL=yes" > /etc/sysconfig/network-scripts/ifcfg-$eth1

echo password|passwd --stdin root
systemctl disable firewalld
systemctl restart network

