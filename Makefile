.DEFAULT_GOAL := help

ifdef DEBIAN_VERSION
	DEBIAN_VERSION = $(DEBIAN_VERSION)
else
	DEBIAN_VERSION = 11.3.0
endif

make-dists: ## Make the directory where the preseeded distribution images will end up
	mkdir -p dists

debian-download-i386: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh i386 $(DEBIAN_VERSION)

debian-build-i386: debian-download-i386 make-dists## Build the 32 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/debian-$(DEBIAN_VERSION)-i386-netinst.iso retronas-debian-$(DEBIAN_VERSION)-i386-netinst.iso 386

debian-download-amd64: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh amd64 $(DEBIAN_VERSION)

debian-build-amd64: debian-download-amd64 make-dists## Build the 64 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/debian-$(DEBIAN_VERSION)-amd64-netinst.iso retronas-debian-$(DEBIAN_VERSION)-amd64-netinst.iso amd

debian-build: debian-build-i386 debian-build-amd64 ## Build for all debian architectures

rpios-init: ## Set up docker container for packer
	cd rpios && docker build -t retronas:packer .

rpios-build: ## Build with packer in docker
	cd rpios && ./build.sh

build-all: debian-build rpios-build ## Build for all distributions

clear-cache: ## Remove all temporary and cached files, not including built dist ISOs
	rm -rf debian/isofiles
	rm debian/iso-cache/*
	rm -rf packer_cache
	rm -rf output-arm-image
	rm rpios/iso-cache/*

help: ## Show this help.
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
