# RetroNAS Distribution Generator

This is a companion repo to https://github.com/danmons/retronas that builds all the distributions of RetroNAS for different platforms. The configuration for each distribution has its own directory and this documentation is broken up by distribution as well.

All the relevant commands can be found by running make. The make commands have prefixes for their distributions, such as debian-build and rpios-build. They are oriented hierarchically so that all the distributions have a single build command that will build everything for that distribution and there is a build-all command that will build every distributions. Built distributions can be found in the dists directory.

Make is the main dependency, and each distribution will have its individual dependencies listed in its section.

# Debian

This builds debian ISO's with customized installers. These are net installers that result in an operating system pre-configured with RetroNAS. Essentially it allows you to turn any standard PC or laptop into a dedicated RetroNAS box without having to do any manual pre-configuration.

### WARNING: YOU WILL LOSE ALL YOUR DATA

The preseeded installer **_completely erases the first disk_** on the computer you install this to. DO NOT use this on any device that could have the slightest possibility of containing any data you want to retain because it will be immediately erased without asking you. Boot it up and look through the filesystem beforehand to make sure. **_By booting this image at all you agree to having your data erased_**.

This is based on the good work done in the repo: https://github.com/istepaniuk/debian11-preseed and the RetroNAS team would very much like to thank its creator Iván Stepaniuk (istepaniuk) for it.

## Usage:

### Installing a RetroNAS Distribution:

1. Download an ISO for your architecture from the releases (i386 for 32 bit and amd64 for 64 bit).
2. Flash the ISO to a USB stick (https://www.balena.io/etcher/) or burn it to a CD. (You could also use a virtual machine)
3. Connect the computer you wish to use to the internet with an ethernet cable.
4. Make sure there are no files you want on the computer, then plug the USB stick in or insert the CD.
5. Boot the computer and enter the BIOS/Boot Device Menu. This is different for each device, but usually you will be prompted to press enter, f12, or f1 during boot.
6. Select the USB stick or CD that contains the RetroNAS ISO to boot from.
7. Debian and RetroNAS should install now. It's possible that some intervention may be required on your part if the installer has a problem with your hardware.
8. When the computer reboots, remove the USB stick or CD.
9. You should now boot in to debian (if you are presented with a GRUB boot menu, you can press enter on the debian option)
10. You can login to debian with the username "pi" and password "retronas". The root password is also "retronas".
11. Type "retronas" and press enter to run RetroNAS.

_Note: The configuration for the boot menu options is specific to bullseye in the case of a UEFI system because grub uses the position of the entry to specify the default option._

### Building your own image:

RetroNAS intends to maintain a release for whatever the current stable version of Debian is. At the time of this writing, that's Bullseye 11.3.0. If, however, you wish to build an installer with a different version, or to edit the preseed, the procedure is quite simple:

1. Install the dependencies: bsdtar(libarchive-tools), cpio, xorriso and curl
2. Clone this repo.
3. Navigate to the retronas-dist directory.
4. Run "make" to see a list of available procedures.
5. Set the version of Debian you want in an environment variable like: export DEBIAN_VERSION=11.3.0
6. Edit the preseed file however you'd like (https://wiki.debian.org/DebianInstaller/Preseed)
7. Run the make command for the architecture you desire (example: "make build-debian-amd64") or "make build-all" to build for all architectures.
8. After building, your ISO(s) will be written to the dists directory and prepended with the name "retronas" and the date.

## How it works:

We build debian ISO's with customized installers. These are net installers that result in an operating system pre-configured with RetroNAS. Essentially it allows you to turn any standard PC or laptop into a dedicated RetroNAS box without having to do any manual pre-configuration.

Every build command has as its dependency a download command. This just looks for the ISO for the specific architecture and version in the appropriate iso-cache directory. If it finds it, then this step is skipped. If not, it downloads the appropriate ISO to that dist's iso-cache directory.

After the ISO is downloaded, the build command is run for the specified architecture. The iso is unpacked into a temporary directory called isofiles. The file "preseed.cfg" is then injected into that ISO's initrd file. Initrd handles the installation of Debian. During the installation it always looks for a file named preseed.cfg for configuration, but it usually doesn't exist so it just performs its default behavior.

The directory "isofiles" is then packed into a new RetroNAS image that you can boot.

When the ISO is booted, the debian installer finds the preseed.cfg file, which feeds it answers to all the questions that would normally require user input. At the end, it runs the "d-i preseed/late_command" from the end of the preseed.cfg file. This performs some configuration, and downloads the install_retronas.sh script from the main RetroNAS repo, then runs it. By using this method we asure that you always get the most up to date version of RetroNAS when using this ISO,
and we don't have to create a new ISO each time RetroNAS is updated.

# Raspberry PI OS

If you want to use your own raspios img file, create the directory rpios/iso-cache and put the img file inside.

1. Install qemu qemu-user-static binfmt-support
2. Run "make rpios-build"
