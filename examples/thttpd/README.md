# thttpd example
This example is designed to present how to build an application and boot it on a minimal VM with a slashed kernel.

You need to copy in "crt1.o", "libc.a" and "libc.a.bc", generated as a result of building the bitcode of musl-libc using [musllvm](https://github.com/SRI-CSL/musllvm).
```
./generate_syscall_list.sh specialize_libc.manifest {filename-for-syscall-Ids} {filename-for-syscall-symbols}
```

The syscall_symbols file that you provide as third argument for the command above can now be used as argument to the [kernel slashing script](../../kernel-slashing/slash_kernel.sh)
