SHELL := /bin/bash

# http://bobbynorton.com/posts/includes-in-dockerfiles-with-m4-and-make/

#
# Parameters
#

OCI_EXE := $(shell command -v podman || command -v docker 2> /dev/null)

# Docker organization to pull the images from
OCIX_REGISTRY := $(shell cat ocix_registry)
# Docker organization to pull the images from
OCIX_PORT := $(shell cat ocix_port)
# Docker organization to pull the images from
OCIX_ORG := $(shell cat ocix_org)

# Exit if we don't have a OCIX_VERSION.
# If the shell has $(export OCIX_VERSION=m.n.o) we'll get that.
OCIX_VERSION := $(shell cat ocix_version)

# Check we have a semantic version, abend. Make doesn't have regular expressions
# so delegate to the shell (defined above)
SEMVER := $(shell [[ $(OCIX_VERSION) =~ ^[0-9]+\.[0-9]+\.[0-9]+$$ ]] && echo semver)

ifdef SEMVER
@echo Semantic version number given: $(OCIX_VERSION)
else
$(error OCIX_VERSION is not semantic version number)
endif

# Tag images with semantic version number.
TAG = $(OCIX_VERSION)

# Directory where to generate the ocix script for each images (e.g bin/ocix-manylinux1-x64)
BIN = ./bin

# # These images are built using the "build implicit rule"
# STANDARD_IMAGES = ocix-base ocix-android-arm ocix-android-arm64 ocix-linux-s390x ocix-linux-arm64 ocix-linux-armv5 ocix-linux-armv5-musl ocix-linux-armv6 ocix-linux-armv7 ocix-linux-armv7a ocix-linux-mips ocix-linux-mipsel ocix-linux-ppc64el ocix-linux-x64 ocix-linux-x86 ocix-windows-static-x86 ocix-windows-static-x64 ocix-windows-static-x64-posix ocix-windows-shared-x86 ocix-windows-shared-x64 ocix-windows-shared-x64-posix

# # Generated Dockerfiles.
# GEN_IMAGES = ocix-linux-s390x ocix-linux-mips ocix-manylinux1-x64 ocix-manylinux1-x86 ocix-manylinux2010-x64 ocix-manylinux2010-x86 ocix-manylinux2014-x64 ocix-web-wasm ocix-linux-arm64 ocix-windows-static-x86 ocix-windows-static-x64 ocix-windows-static-x64-posix ocix-windows-shared-x86 ocix-windows-shared-x64 ocix-windows-shared-x64-posix ocix-linux-armv7 ocix-linux-armv7a ocix-linux-armv5 ocix-linux-armv5-musl ocix-linux-ppc64el
# GEN_IMAGE_DOCKERFILES = $(addsuffix /Dockerfile,$(GEN_IMAGES))

# # These images are expected to have explicit rules for *both* build and testing
# NON_STANDARD_IMAGES = ocix-web-wasm ocix-manylinux1-x64 ocix-manylinux1-x86 ocix-manylinux2010-x64 ocix-manylinux2010-x86 ocix-manylinux2014-x64

# DOCKER_COMPOSITE_SOURCES = common.docker common.debian common.manylinux common.crosstool common.windows

# # This list all available images
# IMAGES = $(STANDARD_IMAGES) $(NON_STANDARD_IMAGES)
DOCKERFILES=$(shell find dockerfiles/ -maxdepth 1 -type f -iname '*.m4' -execdir basename -s '.m4' {} +)
IMAGES=$(subst /,\:,$(subst /Dockerfile,,$(DOCKERFILES)))

# Optional arguments for test runner (test/run.py) associated with "testing implicit rule"
linux-ppc64el.test_ARGS = --languages C
windows-static-x86.test_ARGS = --exe-suffix ".exe"
windows-static-x64.test_ARGS = --exe-suffix ".exe"
windows-static-x64-posix.test_ARGS = --exe-suffix ".exe"
windows-shared-x86.test_ARGS = --exe-suffix ".exe"
windows-shared-x64.test_ARGS = --exe-suffix ".exe"
windows-shared-x64-posix.test_ARGS = --exe-suffix ".exe"

# On CircleCI, do not attempt to delete container
# See https://circleci.com/docs/docker-btrfs-error/
RM = --rm
ifeq ("$(CIRCLECI)", "true")
	RM =
endif

# all targets are phony (no files to check).
.PHONY: check-ocix-base $(IMAGES)
# Prevent implict rule search for files triggering a rebuild of this Makefile
Makefile: ;

LIB = ./dockerfiles

# Dockerfile: $(LIB)/*.m4
# 	m4 -I $(LIB) $(LIB)/$@.m4 > Dockerfile

# build: dockerfile

#
# images: This target builds all IMAGES (because it is the first one, it is built by default)
#
images: $(IMAGES)

#
# test: This target ensures all IMAGES are built and run the associated tests
#
test: $(addsuffix .test,$(IMAGES))

#
# Generic Targets (can specialize later).
#

# $(GEN_IMAGE_DOCKERFILES) Dockerfile: %Dockerfile: %Dockerfile.in $(DOCKER_COMPOSITE_SOURCES)
# 	sed \
# 		-e '/common.docker/ r common.docker' \
# 		-e '/common.debian/ r common.debian' \
# 		-e '/common.manylinux/ r common.manylinux' \
# 		-e '/common.crosstool/ r common.crosstool' \
# 		-e '/common.windows/ r common.windows' \
# 		$< > $@

#
# web-wasm
#
# ocix-web-wasm: ocix-web-wasm/Dockerfile
# # BUILT=$(shell $(OCI_EXE) images -q ocix-web-wasm:$(TAG) 2> /dev/null)
# # ifeq ($(strip $(BUILT)),)
# 	mkdir -p $@/imagefiles && cp -r imagefiles $@/ 
# 	cp -r test ocix-web-wasm/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-web-wasm:$(TAG) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-web-wasm \
# 		--build-arg OCIX_ORG=$(OCIX_ORG) \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		ocix-web-wasm
# 	rm -rf ocix-web-wasm/test
# 	# rm -rf $@/imagefiles
# # endif

ocix-web-wasm.test: ocix-web-wasm
	cp -r test ocix-web-wasm/
	$(OCI_EXE) run $(RM) $(OCIX_REGISTRY)$(OCIX_PORT)/$(OCIX_ORG)/ocix-web-wasm:$(TAG) > $(BIN)/ocix-web-wasm && chmod +x $(BIN)/ocix-web-wasm
	$(BIN)/ocix-web-wasm /usr/local/bin/python4ocixtest test/run.py --exe-suffix ".js"
	rm -rf ocix-web-wasm/test

#
# manylinux2014-x64
#
# ocix-manylinux2014-x64: ocix-manylinux2014-x64/Dockerfile
# 	mkdir -p $@/imagefiles && cp -r imagefiles $@/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-manylinux2014-x64:$(TAG) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-manylinux2014-x64 \
# 		--build-arg OCIX_ORG=$(OCIX_ORG) \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		--file ocix-manylinux2014-x64/Dockerfile .
# 	rm -rf $@/imagefiles

ocix-manylinux2014-x64.test: ocix-manylinux2014-x64
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/ocix-manylinux2014-x64:$(TAG) > $(BIN)/ocix-manylinux2014-x64 && chmod +x $(BIN)/ocix-manylinux2014-x64
	$(BIN)/ocix-manylinux2014-x64 /usr/local/bin/python4ocixtest test/run.py

#
# manylinux2010-x64
#

# ocix-manylinux2010-x64: ocix-manylinux2010-x64/Dockerfile
# 	mkdir -p $@/imagefiles && cp -r imagefiles $@/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-manylinux2010-x64:$(TAG) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-manylinux2010-x64 \
# 		--build-arg OCIX_ORG=$(OCIX_ORG) \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		--file manylinux2010-x64/Dockerfile .
# 	rm -rf $@/imagefiles

ocix-manylinux2010-x64.test: ocix-manylinux2010-x64
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/ocix-manylinux2010-x64:$(TAG) > $(BIN)/ocix-manylinux2010-x64 && chmod +x $(BIN)/ocix-manylinux2010-x64
	$(BIN)/ocix-manylinux2010-x64 /usr/local/bin/python4ocixtest test/run.py

#
# manylinux2010-x86
#

# ocix-manylinux2010-x86: ocix-manylinux2010-x86/Dockerfile
# # BUILT=$(shell $(OCI_EXE) images -q ocix-manylinux2010-x86:$(TAG) 2> /dev/null)
# # ifeq ($(strip $(BUILT)),)
# 	mkdir -p $@/imagefiles && cp -r imagefiles $@/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-manylinux2010-x86:$(TAG) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-manylinux2010-x86 \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		--file manylinux2010-x86/Dockerfile .
# 	# rm -rf $@/imagefiles
# # endif

ocix-manylinux2010-x86.test: ocix-manylinux2010-x86
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/ocix-manylinux2010-x86:$(TAG) > $(BIN)/ocix-manylinux2010-x86 && chmod +x $(BIN)/ocix-manylinux2010-x86
	$(BIN)/ocix-manylinux2010-x86 /usr/local/bin/python4ocixtest test/run.py

#
# manylinux1-x64
#

# ocix-manylinux1-x64: ocix-manylinux1-x64/Dockerfile
# # BUILT=$(shell $(OCI_EXE) images -q ocix-manylinux1-x64:$(TAG) 2> /dev/null)
# # ifeq ($(strip $(BUILT)),)
# 	mkdir -p $@/imagefiles && cp -r imagefiles $@/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-manylinux1-x64:$(TAG) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-manylinux1-x64 \
# 		--build-arg OCIX_ORG=$(OCIX_ORG) \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		--file manylinux1-x64/Dockerfile .
# 	# rm -rf $@/imagefiles
# # endif

ocix-manylinux1-x64.test: ocix-manylinux1-x64
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/ocix-manylinux1-x64:$(TAG) > $(BIN)/ocix-manylinux1-x64 && chmod +x $(BIN)/ocix-manylinux1-x64
	$(BIN)/ocix-manylinux1-x64 /usr/local/bin/python4ocixtest test/run.py

#
# manylinux1-x86
#

# ocix-manylinux1-x86: ocix-manylinux1-x86/Dockerfile
# # BUILT=$(shell $(OCI_EXE) images -q ocix-manylinux1-x86:$(TAG) 2> /dev/null)
# # ifeq ($(strip $(BUILT)),)
# 	mkdir -p $@/imagefiles && cp -f -r imagefiles $@/
# 	$(OCI_EXE) build --tag $(OCIX_ORG)/ocix-manylinux1-x86:$(OCIX_VERSION) \
# 		--build-arg IMAGE=$(OCIX_ORG)/ocix-manylinux1-x86 \
# 		--build-arg OCIX_ORG=$(OCIX_ORG) \
# 		--build-arg OCIX_VERSION=$(OCIX_VERSION) \
# 		--build-arg VCS_REF=`git rev-parse --short HEAD` \
# 		--build-arg VCS_URL=`git config --get remote.origin.url` \
# 		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 		--file manylinux1-x86/Dockerfile .
# 	# rm -rf $@/imagefiles
# # endif

ocix-manylinux1-x86.test: ocix-manylinux1-x86
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/ocix-manylinux1-x86:$(TAG) > $(BIN)/ocix-manylinux1-x86 && chmod +x $(BIN)/ocix-manylinux1-x86
	$(BIN)/ocix-manylinux1-x86 /usr/local/bin/python4ocixtest test/run.py

#
# base
#

# ocix-base:
# 	./scripts/make/build_image.sh $(OCI_EXE) $(OCIX_ORG) $@ $(OCIX_VERSION) $@

# ocix-base.test: ocix-base
# 	$(OCI_EXE) run $(RM) $(OCIX_REGISTRY)$(OCIX_PORT)/$(OCIX_ORG)/ocix-base:$(TAG) > $(BIN)/ocix-base && chmod +x $(BIN)/ocix-base
# 	$(BIN)/ocix-base /usr/local/bin/python4ocixtest test/run.py

#
# display
#
display_images:
	for image in $(IMAGES); do echo $$image; done

$(VERBOSE).SILENT: display_images


check-ocix-base:
ifndef BASE_BUILT
	./scripts/make/build_image.sh $(OCI_EXE) $(OCIX_ORG) ocix-base $(OCIX_VERSION) ocix-base
BASE_BUILT:=true
endif


#
# build implicit rule
#

$(IMAGES): check-ocix-base
	./scripts/make/build_image.sh $(OCI_EXE) $(OCIX_ORG) $@ $(OCIX_VERSION) $@

#
# testing implicit rule
#
$(addsuffix .test,$(IMAGES)): $$(basename $$@)
  mkdir -p $(BIN)
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/$(basename $@):$(TAG) > $(BIN)/$(basename $@) && chmod +x $(BIN)/$(basename $@)
	echo $(BIN)/$(basename $@)
	$(BIN)/$(basename $@) /usr/local/bin/python4ocixtest test/run.py $($@_ARGS)
	rm -rf $(BIN)

#
# testing prerequisites implicit rule
#
# test.prerequisites:
# 	mkdir -p $(BIN)

# $(addsuffix .test,$(IMAGES)): test.prerequisites

.PHONY: images $(IMAGES) test %.test

.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

help:
	$(info The following are some of the valid targets for this Makefile)
	make list
