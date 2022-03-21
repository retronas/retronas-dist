.DEFAULT_GOAL := help
DEBIAN_VERSION=$(shell cat debian/DEBIAN_VERSION)

LOCAL_DIR = $(shell pwd)


make-dists: ## Make the directory where the preseeded distrobution images will end up
	mkdir -p dists

download-debian-i386: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh i386 $(DEBIAN_VERSION)

build-debian-i386: download-debian-i386 make-dists## Build the 32 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/debian-$(DEBIAN_VERSION)-i386-netinst.iso retronas-debian-$(DEBIAN_VERSION)-i386-netinst.iso 386

download-debian-amd64: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh amd64 $(DEBIAN_VERSION)

build-debian-amd64: download-debian-amd64 make-dists## Build the 64 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/debian-$(DEBIAN_VERSION)-amd64-netinst.iso retronas-debian-$(DEBIAN_VERSION)-amd64-netinst.iso amd

build-debian: build-debian-i386 build-debian-amd64 ## Build for all debian architectures

build-all: build-debian-i386 build-debian-amd64 ## Build for all distributions

clear-cache: ## Remove all temporary and cached files, not including built dist ISOs
	rm -rf debian/isofiles
	rm debian/iso-cache/*

help: ## Show this help.
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
