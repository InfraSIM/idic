#IDIC

**idic repo** is platform development kit that is used for creating virtual compute node and virtual PDU(power distribution unit) for building virtual infrastructure. Reference [infrasim document](http://infrasim.readthedocs.org/) for more details.

#Build idic image

##Setup environment
Prior to building idic, you should have Ubuntu 14.04 installed, and have the following packages installed on OS: 

    sudo apt-get install -y mkisofs autoconf pkg-config libtool nsis bison flex libncurses5 libncurses5-dev 
    sudo apt-get install -y zlib1g-dev libglib2.0-dev libpopt-dev libssl-dev python-dev git libdumbnet1 libdumbnet-dev tclsh

**Note:** If you already cloned idic repo, you can just get into the idic project, and then run:

    sudo make setupenv

##Configure idic
There is already one default configuration file: vcompute/&lt;**node name**&gt;/.config or vpdu/&lt;**pdu name**&gt;/.config. You could use that default for config.

If you want to change default configuration, two ways could achieve that:

* Clone idic repo and under idic foler, run below command to change configuration for virtual compute node:

    `fakeroot make menuconfig NODE=vnode`

* To make the configuration to build a virtual PDU:
    
    `fakeroot make menuconfig PDU=vpdu`

* Or, under specific virtual compute node directory (idic/vcomptue/&lt;node name&gt;/), or virtual pdu directory (idic/vpdu/&lt;pdu name&gt;/), and run
    
    `fakeroot make menuconfig`

##Build idic

  Use below command in idic directory to build kernel and ramfs which are base binaries for all virtual compute nodes and PDUs that infraSIM supported 

    `fakeroot make vnode`
  
Or, use below command in folder of specific virtual node to build base binaries for that node only, for example, build binaries for virtual dell r630:
  
    cd vcompute/dell_r630
    make 

**Note:** Once the build is completed successfully, you will find all binaries at pdk/linux/dell_r630:

* ramfs.lzma
* config-x.xx
* System.map-x.xx
* vmlinuz-x.xx

Filename surfix x.xx is version number which is subject to change. All these 4 binaries are required in order to generate virtual machine images for different hypervisors in next step: OVA file for VMWare product; QCOW2 images for KVM; VDI image for virtulbox, etc.

## Create virtual machine images 

Tools repository contains all utilities for converting base binaries to virtual machine images. Here's example on how to create a VMWare OVA image:

Before creating ova image, you should have the following tools installed:

* ovftool
* extlinux
* qemu

Then you can run the [ova builder](https://github.com/InfraSIM/tools/tree/master/ova_builder) script to create the ova.

   cd tools/ova_builder
   sudo ./ova_builder.sh -d your_idic_directory/pdk/linux/dell_r630 -t dell_r630.ova
 
 
Folder your_idic_directory/pdk/linux/dell_r630 is supposed to contain those base binaries. You can refer to [Build Package and Deployment](http://infrasim.readthedocs.org/en/latest/builddeploy.html) for help to build virtual machine images for more types of hypervisor.


##How to run idic

Regarding how to load idic ova image, please reference [idic user guide](http://infrasim.readthedocs.org/en/latest/userguide.html) for more help.

#How to emulate virtual node in idic

##How to add virtual compute node

### How to retrieve static data from physical server

* Retrieve BMC data

    1. Retrive sdr data: `ipmitool sdr dump rj_sensors; sensor_sort rj_sensors`
    2. Retrive fru data: `impitool fru read fru.bin`; dump fru.bin to hex format


* Retrieve smbios data, dump smbios table into a file 

    `dmidecode --dump-bin &lt;target file&gt;`

### Create emulated node in idic

Once you get data from physical server, then you can follow below steps to add a virtual node:

1. Create a directory named **node name** at idic/vcompute

2. Copy the conf and .config from other virtual directory

3. Copy the data you retrieved from physical server to data directory

4. Copy the Makefile from other virtual directory, and Update the target name in Makefile and .config

## How to add virtual PDU

### How to retrieve data from physical PDU

If you want to retrieve PDU MIB data, you should have [**snmpsim**](http://snmpsim.sourceforge.net/) installed on your environment.

Then run the following command to produce MIB snapshot for the PDU:
```
snmprec.py --agent-udpv4-endpoint=&lt;PDU IP address&gt; --start-oid=1.3.6 
--output-file=/path/&lt;target snmprec file&gt; --variation-module=sql 
--variation-module-options=dbtype:sqlite3,database:/path/&lt;target pdu database file&gt;,dbtable:snmprec
```

For more details of how to use snmprec.py, please go to section [Producing SNMP snapshots](http://snmpsim.sourceforge.net/snapshotting.html) at snmpsim home page for more help.


### How to emulate physical PDU in idic

Once you retrieved data from physical PDU, the next step is to add a virtual PDU in idic for this physical server. The folllowing steps will guide you how to do:

1. Create a directory named **PDU name** at idic/vpdu

2. Creat a directory data at idic/vpdu/&lt;PDU name&gt;/data, and copy the data you get from physical server into data directory.

3. Copy .config and Makefile into idic/vpdu/&lt;PDU name&gt;, and update target name in Makefile and .config
