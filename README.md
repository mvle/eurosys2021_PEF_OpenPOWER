Instructions for running the experiments described in our paper:
All experiments require running inside a (S)VM.

We provide 2 images: **fed32-svm** and **fed32**. **fed32-svm** is used for all experiments requiring SVM. **fed32** is used for both non-PEF and PEF enabled hardware but non-SVM experiments.

## Part I: Run SVM and PEF-no-SVM experiments.

### SVM experiments:
- Verify system is booted in PEF: 
    - ls /sys/firmware/ (If ultravisor directory exists, then in PEF mode) 
    - If not in PEF, enable PEF (see instructions below).
- sudo virsh start fed32-svm
- sudo virsh domifaddr fed32-svm (to get IP address)
- ssh root@<fed32-svm IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

### PEF-no-SVM experiments:
- sudo virsh start fed32
- sudo virsh domifaddr fed32 (to get IP address)
- ssh root@<fed32 IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

## Part II: Run non-PEF experiments.

- Disable PEF on the system and power-cycle.
- sudo virsh start fed32
- sudo virsh domifaddr fed32 (to get IP address)
- ssh root@<fed32 IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

## Enabling/disabling PEF:
- ENABLE PEF: nvram -p ibm,skiboot --update-config smf\_mem\_amt=0x1000000000 (configure secure memory to 64GB -- half of memory on system)
- DISABLE PEF: nvram -p ibm,skiboot --update-config smf\_mem\_amt=0x0 (configure secure memory to 0GB)
- ssh root@<hostname> (log into the BMC)
- POWER-CYCLE the machine: obmcutil chassisoff && sleep 10 && systemctl restart mboxd.service && sleep 10 && obmcutil chassison && sleep 10 && obmcutil poweron 

## Experiments to run inside the (S)VMs

### Boot time measurement:
Execute the boot-time.sh script, passing in the target VM name and IP

### Network performance experiments:
- Download and build uperf: https://github.com/uperf/uperf
- In target VM: run the script uperf.sh
- On separate host: run ./uperf -s

NOTE: firewall should be disabled or punch holes for both the uperf master/slave processes.
sudo systemctl stop firewalld

### Block performance experiments:
- Download and build fio: https://github.com/axboe/fio
- Copy fio\_examples/\* into git/fio/examples/
- In target VM:
  -- fio examples/fio-rand-RW.4.fio
  -- fio examples/fio-rand-RW.8.fio
  -- fio examples/fio-rand-RW.16.fio

### CPU performance experiments:
- Run req-install.sh to prepare VM for SPEC CPU2017 installation
- Install SPEC CPU2017 ver 1.1.0

NOTE: Installation of tools need to use default location (src root folder -- just hit enter), changing the default location cause failure
- Copy speccpu2017.cfg into config folder

NOTE: Need sufficient memory in the VM (e.g., 22GB) for the intspeed benchmark, (631.deepsjeng\_s application) will fail to run correctly. Fails to allocate enough space for its hashtable.
- cd into the root CPU SPEC folder
- source shrc
- runcpu --config=<config file name> --reportable intrate
- runcpu --config=<config file name> --reportable intspeed


## OPTIONAL STEPS:
- How to build and run Secure VM using Ultravisor on a OpenPOWER machine: Use Fedora 32 on PowerPC64LE. Steps can be found here: https://github.com/open-power/ultravisor/wiki/How-to-build-and-run-Secure-VM-using-Ultravisor-on-a-OpenPOWER-machine

NOTE: see fed32-enc-svm.swiotlb256.22GB.xml for example of KVM VM spec

