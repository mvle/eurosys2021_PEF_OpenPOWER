Instructions for running the experiments described in the paper.

We provide 2 VM images on the provisioned machines: **fed32-svm** and **fed32**. **fed32-svm** is used for all experiments requiring SVM. **fed32** is used for both non-PEF and PEF enabled hardware but non-SVM experiments. (Provisioned machines are not publicly accessible).

NOTE: To use your own SVM image, see fed32-enc-svm.swiotlb256.22GB.xml for example of KVM VM specification to use.

## Part I: Run SVM and PEF-no-SVM experiments.

### SVM experiments:
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

- Use the provided non-PEF machine or disable PEF on the system and power-cycle described in Enabling/Disabling PEF below.
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
- Download, build, install uperf: https://github.com/uperf/uperf
- Copy bin/uperf to the target VM
- Copy entire uperf install directory to a separate host
- On separate host, copy the uperf.sh script into the root of the uperf installed directory.
- Disable firewall and enable port forwarding:
    - On VM: sudo systemctl stop firewalld
    - On separate host: sudo systemctl stop firewalld
    - On VM's host: ./net\_forwarding.sh
- In target VM: run ./uperf -s 
- On separate host, run the script ./uperf.sh

NOTE: the result value to look for is in *Total* line, e.g., 16.13Mb/s from *Total     62.16MB /  32.33(s) =    16.13Mb/s       22400op/s*

### Block performance experiments:
- yum install fio
- In target VM:
    - fio fio\_examples/fio-rand-RW.4.fio
    - fio fio\_examples/fio-rand-RW.8.fio
    - fio fio\_examples/fio-rand-RW.16.fio

NOTE: the result value to look for is in *Run status group*, e.g., READ: bw=548KiB/s (561kB/s)...and WRITE: bw=364KiB/s (373kB/s)...

### CPU performance experiments:
NOTE: SPEC CPU2017 is not open source. A licensed version is provided for committee evaluators on the designated machines.

Installing SPEC CPU2017
- Run req-install.sh to prepare VM for SPEC CPU2017 installation
- Install SPEC CPU2017 ver 1.1.0

NOTE: Installation of tools need to use default location (src root folder -- just hit enter), changing the default location cause failure
- Copy speccpu2017.cfg into config folder

Running the benchmark:
- cd into the root CPU SPEC folder
- source shrc
- runcpu --config=<config file name> --reportable intrate
- runcpu --config=<config file name> --reportable intspeed

NOTE: Need sufficient memory in the VM (e.g., 22GB) for the intspeed benchmark, (631.deepsjeng\_s application) will fail to run correctly. Fails to allocate enough space for its hashtable.

NOTE: The result to look for is the values in *Est. Base Run Time*
