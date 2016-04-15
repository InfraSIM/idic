.NOTPARALLEL:

include .config
export GIT_USER=$(shell git remote -v | grep fetch | awk  -F "@" '{print $$1}' | awk  -F \/\/ '{print $$2}' )
export JOBS:=$(shell echo ${CONFIG_CC_JOBS} | sed "s/\"//g")
export KERNEL_VERSION:=$(shell echo ${CONFIG_KERNEL_VERSION} | sed "s/\"//g")
export CPU_ARCH:=$(shell echo ${CONFIG_ARCH_TYPE} | sed "s/\"//g")
export BASE?=$(shell pwd)
export PDK?=${BASE}
export LINUX_DIR?=${PDK}/linux
export WORKSPACE=${PDK}/content
export MKFILES=${WORKSPACE}/mkfiles
export KCONFIGS=${WORKSPACE}/kconfigs
export PACKAGES=${WORKSPACE}/packages
export BUILD=${WORKSPACE}/build
export ROOT=${LINUX_DIR}/embedded_rootfs/rootfs
export SCRIPTS=${LINUX_DIR}/embedded_rootfs/scripts
export INITDIR=${LINUX_DIR}/embedded_rootfs/init
export CONFDIR=${LINUX_DIR}/embedded_rootfs/conf
export ETCDIR=${LINUX_DIR}/embedded_rootfs/etc
export RELEASE_DIR?=${LINUX_DIR}/release
export STRIP=$(shell which strip)
export RED=$(shell echo "\033[0;31m")
export GRN=$(shell echo "\033[0;32m")
export YLW=$(shell echo "\033[0;33m")
export WHT=$(shell echo "\033[0;37m")
export BLD=$(shell tput bold)
export RST=$(shell tput sgr0)

export KERNEL_OUT=vmlinuz
export CONFIG_OUT=config
export SYSTEM_OUT=System.map
export INITRD_OUT=ramfs.lzma
export ROOTFS_OUT=rootfs.lzma

TARGETNAME ?= generic

.DEFAULT: help
.PHONY: help
.SILENT: help

#
# Should run as root
#
ifneq ($(shell whoami), root)
    $(error ${BLD} Must build as root, use "fakeroot" or "sudo" if running as normal user ${RST})
endif

#
#  Create a package list
#
ALL_PACKAGES_MK=${shell find ${MKFILES} -name "*.mk" -printf "%f "}
ALL_PACKAGES=${ALL_PACKAGES_MK:.mk=}
CONF_PACKAGES=${shell if [ -e .config ]; then grep CONFIG_PKG.*=y .config | sed "s/CONFIG_PKG_//" | sed "s/=y//";fi}

#
# Setup build configuration
#
.root_complete: .config ${KCONFIGS}/*.kconfig ${MKFILES}/*.mk
	${MAKE} force-build

.PHONY: force-build
force-build: configured oldconfig clean-root ${CONF_PACKAGES}
	touch .root_complete

.SILENT: configured
.PHONY: configured
configured:
	if [ -e .config ]; then true; else echo "Not configured. Run \"make menuconfig\"" && false; fi

.PHONY: ${ALL_PACKAGES}
${ALL_PACKAGES}: ${ROOT} ${BUILD}
	@echo
	@echo "${GRN}**** Now Building: $@${RST}"
	@echo
	${MAKE} -C ${BUILD} -f ${MKFILES}/$@.mk


${BUILD} ${ROOT}:
	mkdir -p $@
	chmod 777 $@

#
# Kconfig rules
#
${PDK}/config/conf ${PDK}/config/mconf: .kconfig_include ${PDK}/config/Makefile
	$(MAKE) CC=gcc CFLAGS=-Os LDFLAGS="" -C ${PDK}/config ncurses conf mconf

.PHONY: menuconfig
menuconfig: ${PDK}/config/mconf
	@${PDK}/config/mconf ${LINUX_DIR}/embedded_rootfs/ramfs.kconfig

.PHONY: config
config: ${PDK}/config/conf
	@${PDK}/config/conf ${LINUX_DIR}/embedded_rootfs/ramfs.kconfig

.PHONY: oldconfig
oldconfig: ${PDK}/config/conf
	@${PDK}//config/conf -s ${LINUX_DIR}/embedded_rootfs/ramfs.kconfig

.PHONY: .kconfig_include
.kconfig_include: ${KCONFIGS}/*.kconfig
	find ${KCONFIGS} -name "*.kconfig" -printf "source \"${KCONFIGS}/%f\"\n" | sort > $@


#
#  Package and embedded root make rules
#

.PHONY: platform-specific

.PHONY: ${TARGETNAME}
${TARGETNAME}: configured .root_complete platform-specific
	@echo
	@echo "${GRN}**** Now Building: ${TARGETNAME} ${RST}"
	@echo
	@if [ -n ${CONFIG_EXTRA_FILES} ]; then cp -fr ${CONFIG_EXTRA_FILES}/* ${ROOT}; fi
	@if [ ! -d ${LINUX_DIR}/${TARGETNAME} ];then mkdir -p ${LINUX_DIR}/$@; fi
	@cd ${ROOT} && find . | cpio -V -o -H newc | lzma -7 > ${LINUX_DIR}/$@/${INITRD_OUT}


#
#  Clean rules
#
.PHONY: clean
clean: clean-root
	@rm -rf ${BUILD} .kconfig_include .config.* .tmpconfig.h
	@$(MAKE) CC=gcc CFLAGS=-Os LDFLAGS="" -C ${PDK}/config clean
	@rm -rf ${LINUX_DIR}/usb
	@${MAKE} -f ${MKFILES}/iso.mk clean

.PHONY: clean-root
clean-root:
	@rm -rf ${LINUX_DIR}/${TARGETNAME} ${ROOT} .root_complete ${LINUX_DIR}/embedded_rootfs/${INITRD_OUT} ${BUILD}/linux/embedded_rootfs/${ROOTFS_OUT} ${RELEASE_DIR}

.PHONY: distclean
distclean:
	@cp .default.config .config
	@${MAKE} -s oldconfig
