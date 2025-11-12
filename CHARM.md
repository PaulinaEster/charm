# Charm++

## Introduction

Charm++ is a message-passing parallel language and runtime system.
It is implemented as a set of libraries for C++, is efficient,
and is portable to a wide variety of parallel machines.
Source code is provided, and non-commercial use is free.


## Getting the Latest Source

You can use anonymous Git access to obtain the latest Charm++ source
code, as follows:

     $ git clone https://github.com/charmplusplus/charm

## Change the Branch
You can change the branch for `shrinkexpand-fix` where the version fixing bugs on the shrink.

## Nodes Configuration for testes
- Compilador: GCC;
- Three hosts with enable ssh each other.

In the tests we use three nodes on the `Cloudlab` with hardware c6220 and 8 cores each. The nodes can make ssh without passkey.

## Build Configuration

### Quick Start:

To enable shrink expand, Charm++ needs to be built with the `--enable-shrinkexpand` option:
    
    $ ./build charm++ netlrts-linux-x86_64 --enable-shrinkexpand

WARNING: this is an experimental feature and **not supported in all charm builds and applications**. Currently, it is tested on `netlrts-{linux/darwin}-x86_64` builds. Support for other Charm++ builds and AMPI applications are under development. It is only tested with RefineLB and GreedyLB load balancing strategies; use other strategies with caution.

### Compile the source for example shrinkexpand
First compile the client on the host master, that is the code for shrink and expand the cores in the hosts.
```
cd ./netlrts-linux-x86_64/examples/charm++/shrink_expand && make client
```

Then compile the jacobi2d-iter in the folder `charm/netlrts-linux-x86_64/examples/charm++/shrink_expand/jacobi2d-iter`, this is the example for shrink and expand.
```
cd ./jacobi2d-iter && make
```

Last we are create the `mynodelistfile` in the folder `charm/netlrts-linux-x86_64/examples/charm++/shrink_expand/jacobi2d-iter` only on the master host. Thats inform the master witch hosts they can use and how many cores is use on each host. The content of the file below, specify two hosts with 8 cores each:

```
    host node-1 root
    host node-1 root
    host node-1 root
    host node-1 root
    host node-1 root
    host node-1 root
    host node-1 root
    host node-1 root
    host node-2 root
    host node-2 root
    host node-2 root
    host node-2 root
    host node-2 root
    host node-2 root
    host node-2 root
    host node-2 root
```

### Running jacobi2d with load balancer
in the folder `charm/netlrts-linux-x86_64/examples/charm++/shrink_expand/jacobi2d-iter` on the master node run the command below, this command run jacobi2d with the charmrun script with 4 processes `+p4`, divided on the hosts defined in the `mynodelistfile`. The `++server-port` define the port where the jacobi2d is running on the hosts.
```
sudo ./charmrun +p4 ./jacobi2d 200 20 +balancer GreedyLB ++nodelist ./mynodelistfile ++server ++server-port 1234
```

### Shrink and Expand Resources
The CCS client to send shrink/expand commands needs to specify the hostname, port number, the old(current) number of processor and the new(future) number of processors:

```bash
 ./client <hostname> <port> <oldprocs> <newprocs>

 #shrink
 sudo ./client node-2 1234 8 4

 # expand
 sudo ./client node-2 1234 4 8
```

### Tests
We tried several tests expand and shrink resources, but not know if the resources are allocated as expected because no success or fail signal are received, and no change in the execution time in the `jacobi2d` with param length 20000, the load balancer no was change after the shrink or expand command. Sometimes the jacobi2d just stoped when the expand or shrink command are executed, because, I supose, the shrink or expand command make the checkpoint/restart and the jacobi2d was no prepared for that or no know that.
