#!/bin/bash
#This script is for RHEL6 or CentOS6 only.
#This script sets up a bond interface bond0 and enslave two 1000Mbps Ethernet interfaces to it.
#by Fisher Wang Liyu (QQ: 6671746)
#Caution: This script hasn't been tested. Please be careful if you want to use it!

echo "####################################################################################"
echo "Kindly be noted that if you need to modify your input, please press ctrl+Backspace."
echo "####################################################################################"

#Set up variables
eth_list=$(dmesg | grep "Up 1000 Mbps" | sed 's/^.*igb: //g' | sed 's/NIC.*$//g' | sort | uniq)
[ $(echo $eth_list | wc -w) -ne 2 ] && echo "The number of the active 1000Mbps Ethernet interfaces isn't 2." && exit 1
eth0=$(echo $eth_list | awk '{print $1}')
eth1=$(echo $eth_list | awk '{print $2}')
read -p "Please input the hostname: " host_name
read -p "Please input the IP address (eg. 192.168.0.10): " ip
read -p "Please input the netmask prefix (eg. 24): " prefix
read -p "Please input the gateway (eg. 192.168.0.1): " gateway
read -p "Please input the bond mode. 0 for round-robin, 1 for active-backup. (eg. 1): " mode
while [ "$mode" != 0 -o "$mode" != 1 ]; do
	echo -e "Only 0 or 1 is acceptable.\n"
	read -p "Please input the bond mode. 0 for round-robin, 1 for active-backup. (eg. 1): " mode
done
if [ $mode == 0]; then
	mode=balance-rr;
else
	mode=activebackup;
fi

#Set up configuration files
echo -e "NETWORKING=yes\nHOSTNAME=$host_name">/etc/sysconfig/network

cat>/etc/sysconfig/network-scripts/ifcfg-$eth0<<EOF
DEVICE=$eth0
BOOTPROTO=none
ONBOOT=yes
SLAVE=yes
MASTER=bond0
EOF

cat>/etc/sysconfig/network-scripts/ifcfg-$eth1<<EOF
DEVICE=$eth1
BOOTPROTO=none
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF

cat>/etc/sysconfig/network-scripts/ifcfg-bond0<<EOF
DEVICE=bond0
BOOTPROTO=none
ONBOOT=yes
IPADDR=$ip
PREFIX=$prefix
GATEWAY=$gateway
EOF

echo -e "alias bond0 bonding\noptions bond0 $mode">>/etc/modprobe.d/dist.conf

#Make effect
echo -e "All the configurations are done. Waiting for the the network restarting.\n"
echo -e "Please remember to reset root password and modify hosts file after the script.\n"
hostname $host_name
service NetworkManager stop
chkconfig NetworkManager off
/etc/init.d/network restart