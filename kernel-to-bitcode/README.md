# Building the Linux Kernel into LLVM Bitcode

In order to apply OCCAM tools on the kernel, we need to have a bitcode base on which we can act.
Getting that bitcode is the goal of the [built-in-parsing.py](built-in-parsing.py) program. It will read all the files included in the built-in.o archive and convert what it can into bitcode, compile and link them.
Its first argument is the folder where the bitcode should be stored, and the rest are folders which should not be translated into bitcode and instead directly linked.

I have also included a previous version of the script which would compile archives individually and link them afterwards. It did not boot when including the ext4 file system or the drivers in the bitcode, contrary to the other script.


## Necessary tools

 - clang
 - [gllvm](https://github.com/SRI-CSL/gllvm)
 - libelf-dev (in order to build the kernel)
 - libncurses-dev (optional - needed for menuconfig)
 
## Step-by-Step

#### Building the kernel

Start off by cloning the linux source code from github

```
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
cd linux-stable
```

Checkout a github version up to 4.16. 4.17 does not support clang 7 or under.

```
git checkout v4.14.34
```

The next step is to create a configuration with respect to which the kernel will be built. 

You can use the default configuration for your current architecture.

```
make defconfig
```

Or use the minimal configuration for quickly running experiments.

```
cp ../miniconfig_x64 .config
```

If you want to create your own configuration, just modify the ".config" file.

Having chosen the configuration, we are ready to build the kernel.


```
while [ ! -e "vmlinux" ]; do
    make vmlinux CC=gclang
done
```
A bug makes the build stop randomly with clang, so we start it again if it is not finished
However, this will loop if there is an actual error.


#### Extracting the bitcode

The [built-in-parsing.py](built-in-parsing.py) script scans the Linux build for "built-in.o" archives and extracts the corresponding bitcode. It also dynamically writes a script that copies all these files into the directory that is specified as the first argument. 

```
mkdir wrapper-logs
export WLLVM_OUTPUT_FILE=wrapper-logs/wrapper.log
python ../built-in-parsing.py {full-path-to-directory-where-the-bitcode-should-be-stored} 
```

The "build_script.sh" would have been created by the previous command which copies all the bitcodes into the build directory and links them to create the vmlinux file. 


#### Installing the kernel

We can now bring back the vmlinux file and install it on our system.

```
cp {full-path-to-directory-where-the-bitcode-should-be-stored}/vmlinux .
cp ../install.sh .
bash install.sh
```

And we are done. We have succesfully built the Linux kernel, extracted its bitcode, linked the bitcodes to create a vmlinux file and installed on our system. Rebooting should be on the installed kernel.