.DEFAULT_GOAL := help
DEBIAN_VERSION=$(shell cat DEBIAN_VERSION)

LOCAL_DIR = $(shell pwd)

init: ## Set up the docker container
	docker build -t retronas:retronas-dist .

download-i386: ## Download the 32 bit debian netinst image
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas:retronas-dist \
	./download-iso.sh i386 $(DEBIAN_VERSION)

build-i386: download-i386 ## Build the 32 bit debian image in the docker container
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas:retronas-dist \
	/build/make-preseed-iso.sh debian-$(DEBIAN_VERSION)-i386-netinst.iso retronas-debian-$(DEBIAN_VERSION)-i386-netinst.iso 386

download-amd64: ## Download the 32 bit debian netinst image
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas:retronas-dist \
	./download-iso.sh amd64 $(DEBIAN_VERSION)

build-amd64: download-amd64 ## Build the 64 bit debian image in the docker container
	docker run \
	-it \
	--rm \
	-v $(LOCAL_DIR):/build \
	--workdir=/build \
	retronas:retronas-dist \
	/build/make-preseed-iso.sh debian-$(DEBIAN_VERSION)-amd64-netinst.iso retronas-debian-$(DEBIAN_VERSION)-amd64-netinst.iso amd

build-all: build-i386 build-amd64 ## Build for all architectures

help: ## Show this help.
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
