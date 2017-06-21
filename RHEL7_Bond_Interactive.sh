#!/bin/bash
#by Fisher Wang Liyu (QQ: 6671746)
#Caution: This script hasn't been tested. Please be careful if you want to use it!

echo "##############################################################################################"
echo "This script is for RHEL7 or CentOS7 only."
echo "This script sets up a bond interface bond0 and enslave two 1000Mbps Ethernet interfaces to it."
echo "Kindly be noted that if you need to modify your input, please press Ctrl+Backspace."
echo "##############################################################################################"

#Set up variables
eth_list=$(dmesg | grep "Up 1000 Mbps" | sed 's/^.*igb: //g' | sed 's/NIC.*$//g' | sort | uniq)
[ $(echo $eth_list | wc -w) -ne 2 ] && echo "The number of the active 1000Mbps Ethernet interfaces isn't 2." && exit 1
eth0=$(echo $eth_list | awk '{print $1}')
eth1=$(echo $eth_list | awk '{print $2}')
read -p "Please input hostname: " host_name
read -p "Please input IP address (eg. 192.168.0.10): " ip
read -p "Please input netmask prefix (eg. 24): " prefix
read -p "Please input gateway (eg. 192.168.0.1): " gateway
read -p "Please input bond mode. 0 for round-robin, 1 for active-backup. (eg. 1): " mode
while [ $mode -ne 0 -a $mode -ne 1 ]; do
	echo "Only 0 or 1 is acceptable."
	read -p "Please input bond mode. 0 for round-robin, 1 for active-backup. (eg. 1): " mode
done
if [ $mode -eq 0]; then
	mode=balance-rr;
else
	mode=activebackup;
fi

#Set up configuration files
cat>/etc/sysconfig/network-scripts/ifcfg-bond0<<EOF
DEVICE=bond0
TYPE=Bond
BONDING_MASTER=yes
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=$mode miimon=100"
IPADDR=$ip
PREFIX=$prefix
GATEWAY=$gateway
EOF

cat>/etc/sysconfig/network-scripts/ifcfg-$eth0<<EOF
DEVICE=$eth0
BOOTPROTO=none
ONBOOT=yes
TYPE=Ethernet
SLAVE=yes
MASTER=bond0
USERCTL=no
EOF

cat>/etc/sysconfig/network-scripts/ifcfg-$eth1<<EOF
DEVICE=$eth1
BOOTPROTO=none
ONBOOT=yes
TYPE=Ethernet
SLAVE=yes
MASTER=bond0
USERCTL=no
EOF

#Make effect
echo "All the configurations are done. Waiting for the the network restarting."
echo "Please remember to reset root password after the script."
hostnamectl set-hostname $host_name
systemctl restart network