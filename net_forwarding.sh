#!/bin/bash

HOSTIP=$1
HOSTPORT=$2 #20000
VMIP=$3
VMPORT=$4 #20000
VMSUBNET=$5 #192.168.122.0/24

sudo iptables -t nat -I PREROUTING -p tcp -d $HOSTIP --dport $HOSTPORT -j DNAT --to-destination $VMIP:$VMPORT
sudo iptables -I FORWARD -m state -d $VMSUBNET --state NEW,RELATED,ESTABLISHED -j ACCEPT
