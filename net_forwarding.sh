#!/bin/bash

HOSTIP=$1
PORTS=$2 
PORTE=$3 
VMIP=$4
VMSUBNET=$5

sudo iptables -t nat -I PREROUTING -p tcp -d $HOSTIP --dport $PORTS:$PORTE -j DNAT --to-destination $VMIP
sudo iptables -t nat -I PREROUTING -p udp -d $HOSTIP --dport $PORTS:$PORTE -j DNAT --to-destination $VMIP
sudo iptables -I FORWARD -m state -d $VMSUBNET --state NEW,RELATED,ESTABLISHED -j ACCEPT
