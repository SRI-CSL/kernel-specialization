# Building a full system from bitcode

With busybox, it is possible to build a small environment to put on top of the kernel which can boot and include the program which will have to be shipped.

The [busybox.sh](busybox.sh) script will create such an environment, with most of the code for the kernel and busybox being translated into bitcode and back.
