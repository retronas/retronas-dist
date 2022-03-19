# retronas-dist
This is a companion repo to https://github.com/danmons/retronas that builds debian ISO's with customized installers. These are net installers that result in an operating system pre-configured with RetroNAS. Essentially it allows you to turn any standard PC or laptop into a dedicated RetroNAS box.

### WARNING: YOU WILL LOSE ALL YOUR DATA

The preseeded installer ***completely erases the first disk***. DO NOT use this on any device that could have the slightest possibility of containing data you want to retain because it will be immediately erased without asking you. ***By booting this image at all you agree to having your data erased***.

This is very much based on the good work done in the repo: https://github.com/istepaniuk/debian11-preseed and RetroNAS team would very much like to thank its creator Iván Stepaniuk (istepaniuk) for it.

## Usage:

### Installing RetroNAS OS:
1. Download an ISO for your architecture from the releases.
2. Flash the ISO to a USB stick (https://www.balena.io/etcher/) or burn it to a CD. (You could also use a virtual machine)
3. Connect the computer you wish to use to the internet with an ethernet cable.
4. Plug the USB stick in or insert the CD.
5. Boot the computer and enter the BIOS/Boot Device Menu. This is different for each device, but usually you will be prompted to press enter, f12, or f1 during boot.
6. Select the USB stick or CD that contains the RetroNAS ISO to boot from.
7. Debian and RetroNAS should install now. It's possible that some intervention may be required on your part if the installer has a problem with your hardware.
8. When the computer reboots, remove the USB stick or CD.
9. You should now boot in to debian (if you are presented with a GRUB menu, you can press enter on the debian option)
10. You can login to debian with the username "pi" and password "retronas". The root password is also "retronas".
11. Type "retronas" and press enter to run RetroNAS.

### Building your own image:
RetroNAS intends to maintain a release for whatever the current stable version of Debian is. At the time of this writing, that's Bullseye 11.2.0. If, however, you wish to build an installer with a different version, or to edit the preseed, the procedure is quite simple:

1. Clone this repo.
2. Install Docker: https://docs.docker.com/get-docker/
3. Navigate to the retronas-dist directory.
4. Run "make" to see a list of available procedures.
5. Run "make init" to build the docker container and perform initial setup.
6. Open the DEBIAN_VERSION file and change it to whatever version you'd like.
7. Edit the preseed file however you'd like (https://wiki.debian.org/DebianInstaller/Preseed)
8. Run the make command for the architecture you desire (example: "make build-amd64") or "make build-all" to build all architectures.
9. After building, your ISO will be written to the retronas-dist directory and prepended with the name "retronas" and the date.

## How it works:

The Makefile is just a simple shorthand for docker commands. Everything is run in a Debian container with the dependencies installed for simplicity. The only real dependencies are libarchive-tools, cpio, xorriso, and curl, so you could probably run this on your own OS just fine if you're using Linux.

Every build command has as its dependency a download command. This just looks for the ISO for the specific architecture and version in the directory. If it finds it, then this step is skipped. If not, it downloads the ISO. 

After the ISO is downloaded, it's unpacked into a directory called isofiles. The file "preseed.cfg" is injected into that ISO's initrd file. This file handles the installation of Debian. During the installation it always looks for a file of this name for configuration, but it usually doesn't exist so it just performs its default behavior.

The directory "isofiles" is then packed back up into a new RetroNAS image that you can boot.

*Note: The configuration for the boot menu options is specific to bullseye in the case of a UEFI system because grub uses the position of the entry to specify the default option.*
