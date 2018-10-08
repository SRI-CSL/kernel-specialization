# thttpd example
This example is designed to present how to create a version of kernel specialized with respect to a target application and boot it on the slashed kernel.

We specialize the kernel using the following steps:
1) Create a version of libc specialized with respect to the init utilities and the target program(thttpd in this case).
2) Parse the libc to get a specialized system call list.
3) Specialize the kernel with respect to that list.

The following script implements steps (1) and (2). It takes as argument the file to which you want to write the system call Ids generated and the file to which you want to write the corresponding symbol list.

You need to copy in "crt1.o", "libc.a" and "libc.a.bc", generated as a result of building the bitcode of musl-libc using [musllvm](https://github.com/SRI-CSL/musllvm).
```
./generate_syscall_list.sh specialize_libc.manifest {filename-for-syscall-Ids} {filename-for-syscall-symbols}
```
The symbols file that you provide as third argument for the command above can now be used as argument to the [kernel slashing script](../../kernel-slashing/slash_kernel.sh) to implement step (3).
