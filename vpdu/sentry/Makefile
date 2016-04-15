export BASE := $(shell pwd)
export VPDU_BASE := ${BASE}/..
TARGETNAME = sentry
export LINUX_DIR = ${VPDU_BASE}/../pdk/linux
export RELEASE_DIR = ${LINUX_DIR}/${TARGETNAME}

.PHONY: all
all: ${TARGETNAME}

include ${VPDU_BASE}/Makefile.common

