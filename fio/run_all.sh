#!/bin/bash


## run all direct i/o cases
./run.sh configs_direct/fio-seq-read.mvle.fio configs_direct/fio-seq-read.mvle.8.fio configs_direct/fio-seq-read.mvle.16.fio configs_direct/fio-seq-read.mvle.32.fio configs_direct/fio-seq-read.mvle.64.fio configs_direct/fio-seq-read.mvle.128.fio && mv results results.read && rm -f fio-seq-reads && ./run.sh configs_direct/fio-seq-write.mvle.fio configs_direct/fio-seq-write.mvle.8.fio configs_direct/fio-seq-write.mvle.16.fio configs_direct/fio-seq-write.mvle.32.fio configs_direct/fio-seq-write.mvle.64.fio configs_direct/fio-seq-write.mvle.128.fio && mv results results.write

## run all buffered i/o cases
./run.sh configs_buffered/fio-seq-read.mvle.fio configs_buffered/fio-seq-read.mvle.8.fio configs_buffered/fio-seq-read.mvle.16.fio configs_buffered/fio-seq-read.mvle.32.fio configs_buffered/fio-seq-read.mvle.64.fio configs_buffered/fio-seq-read.mvle.128.fio && mv results results.read.buffered && rm -f fio-seq-reads && ./run.sh configs_buffered/fio-seq-write.mvle.fio configs_buffered/fio-seq-write.mvle.8.fio configs_buffered/fio-seq-write.mvle.16.fio configs_buffered/fio-seq-write.mvle.32.fio configs_buffered/fio-seq-write.mvle.64.fio configs_buffered/fio-seq-write.mvle.128.fio && mv results results.write.buffered
