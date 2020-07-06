SHELL := /bin/bash
LIB = ./dockerfiles
# Testing directory for each image ocix script (e.g bin/ocix-manylinux1-x64)
BIN = $(shell [ -d /work ] && echo /work/bin || echo ./scratch/bin )
# OCI engine
OCI_EXE := $(shell command -v podman || command -v docker 2> /dev/null)
# OCI Registry to push/pull the images to/from
OCIX_REGISTRY := $(shell cat ocix_registry)
# OCI Registry port to push/pull the images to/from
OCIX_PORT := $(shell cat ocix_port)
# OCI Registry organization to push/pull the images to/from
OCIX_ORG := $(shell cat ocix_org)
# OCI version number to push/pull the images to/from
OCIX_VERSION := $(shell cat ocix_version)
# Make doesn't have regular expressions. Delegate to the shell.
SEMVER := $(shell [[ $(OCIX_VERSION) =~ ^[0-9]+\.[0-9]+\.[0-9]+$$ ]] && echo good)
# Check we have a semantic version. If not, abend. 
ifdef SEMVER
@echo Semantic version number given: $(OCIX_VERSION)
else
$(error OCIX_VERSION is not semantic version number)
endif

DOCKERFILES=$(shell find dockerfiles/ -maxdepth 1 -type f -iname '*.m4' -execdir basename -s '.m4' {} +)
IMAGES=$(subst /,\:,$(subst /Dockerfile,,$(DOCKERFILES)))

# Optional arguments for test runner (test/run.py) associated with "testing implicit rule"
linux-ppc64el.test_ARGS = --languages C
ocix-web-wasm.test_ARGS = --exe-suffix ".js"
ocix-windows-static-x86.test_ARGS = --exe-suffix ".exe"
ocix-windows-static-x64.test_ARGS = --exe-suffix ".exe"
ocix-windows-static-x64-posix.test_ARGS = --exe-suffix ".exe"
ocix-windows-shared-x86.test_ARGS = --exe-suffix ".exe"
ocix-windows-shared-x64.test_ARGS = --exe-suffix ".exe"
ocix-windows-shared-x64-posix.test_ARGS = --exe-suffix ".exe"

# On CircleCI, do not attempt to delete container
# See https://circleci.com/docs/docker-btrfs-error/
RM = --rm
ifeq ("$(CIRCLECI)", "true")
	RM =
endif

# all targets are phony (no files to check).
.PHONY: check-ocix-base help images  list $(IMAGES) %.test test 

#
# images: Build all IMAGES (because it is the first one, it is built by default)
#
images: $(IMAGES)

#
# test: This target ensures all IMAGES are built and run the associated tests
#
test: $(addsuffix .test,$(IMAGES))

#
# display
#
list_images:
	$(info The following are the OCI-Cross images this Makefile can build)
	for image in $(IMAGES); do echo $$image; done

$(VERBOSE).SILENT: list_images

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
# test implicit rule
#
$(addsuffix .test,$(IMAGES)): $(basename $@)
	mkdir -p $(BIN)
	ls -la .
	$(OCI_EXE) run $(RM) $(OCIX_ORG)/$(basename $@):$(OCIX_VERSION) > \
	               $(BIN)/$(basename $@) && \
								 chmod a+x $(BIN)/$(basename $@)
	$(BIN)/$(basename $@) /usr/local/bin/python4ocixtest test/run.py $($@_ARGS)
	rm -rf $(BIN)

list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

help:
	$(info The following are some of the valid targets for this Makefile)
	make list

# Prevent implict rule search for files triggering a rebuild of this Makefile
Makefile: ;
