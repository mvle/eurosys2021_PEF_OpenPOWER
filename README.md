Instructions for running the experiments described in our paper:
All experiments require running inside a VM.
Steps for building SVMs can be found in: https://github.com/open-power/ultravisor/wiki/How-to-build-and-run-Secure-VM-using-Ultravisor-on-a-OpenPOWER-machine
## VM image build:
- VM image: Fedora 32 on PowerPC64LE

NOTE: see fed32-enc-svm.swiotlb256.22GB.xml for example of VM spec

## Boot time measurement:
Execute the boot-time.sh script, passing in the target VM name and IP

## Network performance experiments:
- Download and build uperf: https://github.com/uperf/uperf
- In target VM: run the script uperf.sh
- On separate host: run ./uperf -s

NOTE: firewall should be disabled or punch holes for both the uperf master/slave processes.
sudo systemctl stop firewalld

## Block performance experiments:
- Download and build fio: https://github.com/axboe/fio
- In target VM:

## CPU performance experiments:
- Run req-install.sh to prepare VM for SPEC CPU2017 installation
- Install SPEC CPU2017 ver 1.1.0

NOTE: Installation of tools need to use default location (src root folder -- just hit enter), changing the default location cause failure
- Copy speccpu2017.cfg into config folder

NOTE: Need sufficient memory in the VM (e.g., 22GB) for the intspeed benchmark, (631.deepsjeng\_s application) will fail to run correctly. Fails to allocate enough space for its hashtable.
- cd into the root CPU SPEC folder
- source shrc
- runcpu --config=<config file name> --reportable intrate
- runcpu --config=<config file name> --reportable intspeed
