export BASE := $(shell pwd)
VCOMPUTE_BASE = ${BASE}/..
TARGETNAME = dell_c6320
export LINUX_DIR = ${VCOMPUTE_BASE}/../pdk/linux
export RELEASE_DIR = ${LINUX_DIR}/${TARGETNAME}

.PHONY: all
all: ${TARGETNAME}

include ${VCOMPUTE_BASE}/Makefile.common

