### Compiling Xen From Source

Xen 3.3 has better support for pure virtualisation, so we decided to go with that over ubuntu's packed version which is 3.2, ubuntu also appear to be discontinuing support for xen at this time.

This is mostly taken from [This Tutorial](http://www.nabble.com/Installing-Xen-3.3.1-from-sources-on-Hardy-or-Lenny.-td22149817.html) but i skipped some parts of it and stream lined others, also added in the bit about vnc at the end.

##### Packages

First off packages, this may change with latter releases but as of Xen 3.3.1 you need the following:

	
	apt-get install bcc bin86 build-essential comerr-dev debhelper defoma diffstat dpkg-dev fontconfig fontconfig-config g++ g++-4.2 gawk gettext ghostscript graphviz gs-common gsfonts html2text intltool-debian libc6-dev-i386 libc6-i386 libcairo2 libcupsimage2 libcupsys2 libcurl4-openssl-dev libdatrie0 libdrm2 libfontconfig1 libfreetype6 libgd2-noxpm libgl1-mesa-dev libgl1-mesa-glx libglib2.0-0 libglu1-mesa libglu1-mesa-dev libglu1-xorg-dev libgraphviz4 libgs8 libice6 libidn11-dev libjpeg62 libjpeg62-dev libkadm55 libkpathsea4 libkrb5-dev libldap2-dev libltdl3 libncurses5-dev libpango1.0-0 libpango1.0-common libpaper1 libpcre3 libpixman-1-0 libpng12-0 libpoppler2 libpthread-stubs0 libpthread-stubs0-dev libsdl1.2-dev libsm6 libssl-dev libstdc++6-4.2-dev libthai-data libthai0 libtiff4 libtimedate-perl libvncserver-dev libvncserver0 libx11-6 libx11-data libx11-dev libxau-dev libxau6 libxaw7 libxcb-xlib0 libxcb-xlib0-dev libxcb1 libxcb1-dev libxdamage1 libxdmcp-dev libxdmcp6 libxext6 libxfixes3 libxft2 libxml2-dev libxmu6 libxpm4 libxrender1 libxt6 libxxf86vm1 make mesa-common-dev mercurial patch pciutils-dev pkg-config po-debconf python-all python-all-dev python2.4 python2.4-dev python2.4-minimal quilt tex-common texinfo texlive-base texlive-base-bin texlive-common texlive-doc-base texlive-fonts-recommended texlive-latex-base texlive-latex-recommended transfig ttf-dejavu ttf-dejavu-core ttf-dejavu-extra x11-common x11proto-core-dev x11proto-input-dev x11proto-kb-dev xtrans-dev zlib1g-dev binutils binutils-static bridge-utils debootstrap gcc gcc-4.2 libasound2 libbeecrypt6 libc6-dev libconfig-inifiles-perl libcurl3 libdirectfb-1.0-0 libexpect-perl libgomp1 libio-pty-perl libio-stty-perl libneon27 librpm4.4 libsdl1.2debian libsdl1.2debian-alsa libterm-readline-gnu-perl libterm-size-perl libtext-template-perl libxml2 linux-libc-dev linux-restricted-modules-common nvidia-kernel-common perl-doc python-dev python2.5-dev rinse rpm screen sgml-base vnstat xen-shell xen-tools xfsprogs xml-core python-xml


#### Compiling

then you gonna need the source, get it from www.xen.org

create a directory somewhere, untar the source into it, cd to the directory

	
	# make dist
	(takes about 40 minutes)
	# make install


#### Boot Loader

now your should have xen installed and almost ready to go, you need to create an initramfs for the new xen kernel, and update grub to use it:

	
	# depmod -a 2.6.18.8-xen
	# update-initramfs -k 2.6.18.8-xen -c -u
	# update-grub


check /boot/grub/menu.lst has default set to the Xen Kernel Image

#### Start Xen on Boot

finally set xen to start up automatically

	
	update-rc.d xend defaults 20 21
	update-rc.d xendomains defaults 21 20


you should now be all done, once you reboot the system should be ready to use Xen

### VNC Connections to DomUs

VNC Connections can be made to the DOMUs using there video ports from the host system.

To set this up VNC needs to be installed on the host system, along with a bunch of other packages, assuming Ubuntu Server is the base install

I used the following packages to get it working

	
	# apt-get install xtightvncserver xtightvncviewer xorg

