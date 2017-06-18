#!/bin/bash
#This script setups a bonding interface bond0 and enslave two 1000Mbps Ethernet interfaces to it.
#by Fisher Wang Liyu (QQ: 6671746)
#This script hasn't been tested. Please be careful if you want to use it:)

#echo "####################################################################################"
#echo "Kindly be noted that if you need to modify your input, please press ctrl+Backspace."
#echo "####################################################################################"

#set variables
eth_list=$(dmesg | grep "Up 1000 Mbps" | sed 's/^.*igb: //g' | sed 's/NIC.*$//g' | sort | uniq)
[ $(echo $eth_list | wc -w) -ne 2 ] && echo "The number of the active 1000Mbps Ethernet interfaces is incorrect." && exit 1
eth0=$(echo $eth_list | awk '{printf $1}')
eth1=$(echo $eth_list | awk '{printf $2}')
read -p "Please input the hostname: " hostname
read -p "Please input the IP address (eg. 192.168.0.10): " ip
read -p "Please input the netmask prefix (eg. 24): " prefix
read -p "Please input the gateway (eg. 192.168.0.1)： " gateway
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

#set config files
hostnamectl set-hostname $hostname
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
MASTER=bond0
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
SLAVE=yes
USERCTL=no
EOF

cat>/etc/sysconfig/network-scripts/ifcfg-$eth1<<EOF
DEVICE=$eth1
MASTER=bond0
TYPE=Ethernet
BOOTPROTO=none
ONBOOT=yes
SLAVE=yes
USERCTL=no
EOF

#Make effect
echo -e "All the configurations are done. Waiting the the network restarting.\n"
echo -e "Please reset root password after the script.\n"
systemctl restart network

