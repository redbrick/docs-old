# Building a kernel for Ubuntu

## Who should read this?
This describes how to build a patched kernel for Ubuntu (should also work for Debian) using the tools provided (make-kpkg, etc). There are a few ways described in the Ubuntu wiki on how to do this, but you most likely want to follow the route here.

The original use for this when we needed to apply an important security patch to the current kernel release. The result is a kernel that is otherwise identical to the stock kernel (all of the Ubuntu patches, configured the same way).

## Required bits

    sudo apt-get install linux-kernel-devel fakeroot build-essential
    sudo apt-get build-dep linux
    sudo apt-get install linux-source

## Prepare the source tree

Change directory to a temporary directory. Preferably somewhere with fast disks (so, not minerva!) and the ability to execute stuff (so, not /var/tmp if noexec is set). /fast-storage or /tmp may work.

Extract the source tree
    tar xjvf /usr/src/linux-soruce-(version_number).tar.bz2
Copy the existing kernel config. This is the equivalent to running make menuconfig (a kernel config utility) and selecting all of the options chosen by the ubuntu devs.
    cp /boot/config-$(uname -r) .config
(the . in front of .config is important!)

Now, apply any changes to the source tree (for example, security patches).

## Start the build

Choose the concurrency level (choose the number of cores + 1 if the system isn't doing anything else).

    export CONCURRENCY_LEVEL=3

Start the build.

    fakeroot make-kpkg --initrd --append-to-version=-omgcustomversion kernel-image kernel-headers

This should produce a couple of .debs in the parent directory that can be installed. Install the kernel image first, then the headers.

In addition, this will produce kernels with debug symbols enabled, so the files will be huge. It shouldn't affect performance. If you want to disable debug info, install the ncurses and ncurses dev libraries, and run make menuconfig before building. Go into "Kernel Hacking" and disable debug info. Save the config then exit and continue as normal.

## More information

https://help.ubuntu.com/community/Kernel/Compile The Ubuntu kernel building guide. This contains a few options that will produce different results, but may be useful as a reference.

