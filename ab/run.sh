#!/bin/bash

host=$1
conc=1

mv results results.bak

ab -c $conc -t 120 -n 5000000 http://$host/200B 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/2K 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/5K 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/200K 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/500K 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/1M 2>&1 | tee -a results
ab -c $conc -t 120 -n 5000000 http://$host/2M 2>&1 | tee -a results
