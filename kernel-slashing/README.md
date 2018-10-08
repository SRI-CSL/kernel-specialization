This folder gathers scripts used for using OCCAM's razor on the Linux kernel.

## How to use the scripts

Make sure you have [OCCAM](https://github.com/SRI-CSL/OCCAM) installed.

You need to provide the full path to the bitcode built after running the built-in-parsing script (bitcode-build if you ran the example build). 

The second argument is the syscall list. If you have generated a specialized list of system calls
(e.g from the examples directory) use that. Otherwise use the [full syscall.list](syscall.list).


```
./slash_kernel.sh {full-path-to-bitcode-build} {syscall-list}
```
