#!/bin/bash
  
#mv results results.bak

for x in $@
do
  for i in 1 2 3
   do
     fio $x 2>&1 >> results
   done
done
