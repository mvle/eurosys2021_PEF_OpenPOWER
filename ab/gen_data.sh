#!/bin/bash

D="/var/www/html"

dd if=/dev/urandom of=$D/200B bs=1 count=200
dd if=/dev/urandom of=$D/2K bs=1k count=2
dd if=/dev/urandom of=$D/200K bs=1k count=200
dd if=/dev/urandom of=$D/5K bs=1k count=5
dd if=/dev/urandom of=$D/500K bs=1k count=500
dd if=/dev/urandom of=$D/1M bs=1M count=1
dd if=/dev/urandom of=$D/2M bs=1M count=2
