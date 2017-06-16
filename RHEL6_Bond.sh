#!/bin/bash

iptables -F
service iptables stop
chkconfig iptables off
service NetworkManager stop
chkconfig NetworkManager off

# set bond

eth0=
eth1=

hostname=
ip=
netmask=
gateway=

echo  HOSTNAMEING=YES > /etc/sysconfig/network
echo  HOSTNAME=$hostname>> /etc/sysconfig/network
hostname $hostname

echo -e "DEVICE=bond0\nBOOTPROTO=none\nONBOOT=yes\nPEERDNS=yes\nUSERCTL=no\nIPADDR=$ip\nNETMASK=$netmask\nGATEWAY=$gateway" > /etc/sysconfig/network-scripts/ifcfg-bond0
echo -e "DEVICE=$eth0\nBOOTPROTO=none\nONBOOT=yes\nUSERCTL=yes\nTYPE=Ethernet\nSLAVE=yes\nMASTER=bond0"> /etc/sysconfig/network-scripts/ifcfg-$eth0
echo -e "DEVICE=$eth1\nBOOTPROTO=none\nONBOOT=yes\nUSERCTL=yes\nTYPE=Ethernet\nSLAVE=yes\nMASTER=bond0"> /etc/sysconfig/network-scripts/ifcfg-$eth1

echo  "alias bond0 bonding"                 >> /etc/modprobe.d/dist.conf
echo  "options bond0 miimon=100 mode=1     >> /etc/modprobe.d/dist.conf

echo password|passwd --stdin root

/etc/init.d/network restart
