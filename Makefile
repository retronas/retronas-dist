.DEFAULT_GOAL := help

make-dists: ## Make the directory where the preseeded distribution images will end up
	mkdir -p dists

download-debian-i386: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh i386

build-debian-i386: download-debian-i386 make-dists ## Build the 32 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/$(notdir $(shell ls debian/iso-cache/debian-*-i386-netinst.iso | head -1)) 386

download-debian-amd64: ## Download the 32 bit debian netinst image
	cd debian && ./download-iso.sh amd64

build-debian-amd64: download-debian-amd64 make-dists ## Build the 64 bit debian image in the docker container
	cd debian && ./make-preseed-iso.sh iso-cache/$(notdir $(shell ls debian/iso-cache/debian-*-amd64-netinst.iso | head -1)) amd

build-debian: build-debian-i386 build-debian-amd64 ## build for all debian architectures

build-rpios-armhf: ## Build rpios image
	cd rpios && ./build_armhf.sh

build-rpios-arm64: ## Build rpios image
	cd rpios && ./build_arm64.sh

build-rpios: build-rpios-armhf build-rpios-amd64

build-all: 
	build-debian
	build-rpios

clear-cache: ## Remove all temporary and cached files, not including built dist ISOs
	rm -rf debian/isofiles
	rm debian/iso-cache/*
	rm -rf packer_cache
	rm -rf output-arm-image
	rm rpios/iso-cache/*

help: ## Show this help.
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
