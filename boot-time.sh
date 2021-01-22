#!/bin/bash


sudo virsh start $1

SECONDS=0

HOSTIP=$2
ret=1
while [ $ret -ne 0 ]
do
	ssh -o ConnectTimeout=1 root@$HOSTIP echo
        ret=$?
done

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."


sudo virsh shutdown $1
