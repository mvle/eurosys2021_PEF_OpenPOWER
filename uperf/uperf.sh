#!/bin/bash

for x in "share/netperf.xml" "share/netperf.180.xml" "share/netperf.270.xml" "share/netperf.500.xml" "share/netperf.750.xml"
do
  echo $x
  for i in {1..3}
  do
   env h=<slave IP> proto=tcp ./bin/uperf -m $x
  done
done
