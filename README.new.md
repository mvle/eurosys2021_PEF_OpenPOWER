Instructions for running the experiments described in the paper.

We provide 2 VM images on the provisioned machines: **fed32-svm** and **fed32**. **fed32-svm** is used for all experiments requiring SVM. **fed32** is used for both non-PEF and PEF enabled hardware but non-SVM experiments. (Provisioned machines are not publicly accessible).

NOTE: To use your own SVM image, see fed32-enc-svm.swiotlb256.22GB.xml for example of KVM VM specification to use.

## Part I: Run SVM and PEF-no-SVM experiments.

### SVM experiments:
- sudo virsh start fed32-svm
- sudo virsh domifaddr fed32-svm (to get IP address)
- ssh root@\<fed32-svm IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

### PEF-no-SVM experiments:
- sudo virsh start fed32
- sudo virsh domifaddr fed32 (to get IP address)
- ssh root@\<fed32 IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

## Part II: Run non-PEF experiments.

- *(Skip if using provided machine)* Disable PEF on the system and power-cycle described in Enabling/Disabling PEF below.
- sudo virsh start fed32
- sudo virsh domifaddr fed32 (to get IP address)
- ssh root@\<fed32 IP>
- Go to <Experiments to run inside the (S)VMs> section and run all the experiments there

## Enabling/disabling PEF:
- ENABLE PEF: nvram -p ibm,skiboot --update-config smf\_mem\_amt=0x1000000000 (configure secure memory to 64GB -- half of memory on system)
- DISABLE PEF: nvram -p ibm,skiboot --update-config smf\_mem\_amt=0x0 (configure secure memory to 0GB)
- ssh root@\<hostname> (log into the BMC)
- POWER-CYCLE the machine: obmcutil chassisoff && sleep 10 && systemctl restart mboxd.service && sleep 10 && obmcutil chassison && sleep 10 && obmcutil poweron 

## Experiments to run inside the (S)VMs
Git clone this repo onto the host machine.

### Boot time measurement:
Execute the provided boot-time.sh script, passing in the target VM name and IP.

### CPU performance experiments:
NOTE: SPEC CPU2017 is not open source. A licensed version is provided for committee evaluators on the designated machines.

Installing SPEC CPU2017 *(Skip if using provided VM images)*
- Run req-install.sh to prepare VM for SPEC CPU2017 installation
- Install SPEC CPU2017 ver 1.1.0

NOTE: Installation of tools need to use default location (src root folder -- just hit enter), changing the default location cause failure

- Copy speccpu2017.cfg into config folder *(Skip if using provided VM images)*

Running the benchmark:
- cd into the root CPU SPEC folder
- source shrc
- runcpu --config=\<config file name> --reportable intrate
- runcpu --config=\<config file name> --reportable intspeed

NOTE: Need sufficient memory in the VM (e.g., 22GB) for the intspeed benchmark, (631.deepsjeng\_s application) will fail to run correctly. Fails to allocate enough space for its hashtable.

NOTE: The result to look for is the values in *Est. Base Run Time*

### Block performance experiments:
- *(Skip if using provided VM image)* yum install fio
- In target VM:
    ~~- fio fio\_examples/fio-rand-RW.4.fio
    ~~- fio fio\_examples/fio-rand-RW.8.fio
    ~~- fio fio\_examples/fio-rand-RW.16.fio
    - cd into *fio* directory pulled from this repo
    - ./run\_all.sh

NOTE: the result value to look for is in *Run status group*, e.g., READ: bw=548KiB/s (561kB/s)...and WRITE: bw=364KiB/s (373kB/s)...

### Network performance experiments:
- Download, build, install netperf for POWER from the provided SRPM
    - rpm -ivh netperf/netperf-2.7.0-benchmark.11.10.src.rpm (this will install source package into ~/rpmbuild)
    - cd ~/rpmbuild/SPECS
    - edit netperf.spec (comment out lines 34 and 35)
    - rpmbuild -bi
    - binary will be installed in *~/rpmbuild/BUILDROOT/netperf-2.7.0-benchmark.11.10.ppc64le/usr/*
- Copy *~/rpmbuild/BUILDROOT/netperf-2.7.0-benchmark.11.10.ppc64le/* to the target VM
- Disable firewall and enable port forwarding:
    - On VM: sudo systemctl stop firewalld
    - On VM's host, use provided script: ./net\_forwarding.sh \<HOSTIP> \<PORTS> \<PORTS> \<VMIP> \<VMSUBNET>
      <br> e.g., ./net_forwarding.sh 120.5.253.43 20000 20001 192.168.122.53 192.168.122.0/24
- In target VM: \<folder of netperf>/bin/netserver -p 20000 -D -f
- On separate host, copy the provided *netperf/run.sh* into *~/rpmbuild/BUILDROOT/netperf-2.7.0-benchmark.11.10.ppc64le/usr/*
    - run the provided script ./run.sh \<host name of VM's host>

NOTE: the result collected is in the THROUGHPUT column


### Apache Benchmark
- On VM:
    - install *httpd*: yum install httpd
    - service httpd start
    - run provided script to generate data: ./ab/gen\_data.sh
    - Disable firewalld: service firewalld stop
- On VM's host:
    - Enable port forwarding to the target VM: ./net\_forwarding.sh 120.5.253.43 80 80 192.168.122.53 192.168.122.0/24
- On separate host
    - install *ab*: sudo yum install httpd
    - ./ab/run.sh \<host of target VM>
