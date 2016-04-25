.NOTPARALLEL:

-include ${BASE}/.config

PKG:=linux
VER:=${shell echo ${CONFIG_KERNEL_VERSION} | sed "s/\"//g"}
DIR:=${PKG}-${VER}
DEFAULT_CONFIG:=${PDK}/linux/kernel/${VER}/kernel-${VER}.config
INSTALLKERNEL=installkernel-idic

KERNELPRE=${shell echo ${VER} | cut -c1-3}
ifeq ($(findstring 3.,$(KERNELPRE)), 3.)
   KERNELPRE=3.x
endif
ifeq ($(findstring 4.,$(KERNELPRE)), 4.)
   KERNELPRE=4.x
endif

KERNELURL=http://www.kernel.org/pub/linux/kernel/v${KERNELPRE}/

MSTR=""
ifeq (${KERNELPRE}, 2.6)
    MICRO=${shell echo ${VER}|cut -c8-15}
    ifneq (${MICRO}, )
       MSTR=".${MICRO}"
    endif
    KERNELURL=${shell if [ ${MICRO} -gt 7 ]; then echo "http://www.kernel.org/pub/linux/kernel/v2.6/longterm/v`echo ${VER}|cut -c1-6`"; else echo "http://www.kernel.org/pub/linux/kernel/v2.6"; fi}
endif

KERNEL_PATCH_LIST=${shell find ${LINUX_DIR}/kernel/${VER}${MSTR} -name *patch}

COPTS:=${shell echo ${CONFIG_KERNEL_CC} | sed "s/\"//g"}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	@${MAKE} -j${JOBS} -C ${DIR} bzImage HOSTCC=${COPTS} CC=${COPTS}

.PHONY: install
install:
	@mkdir -p ${RELEASE_DIR}
	@${MAKE} -j${JOBS} -C ${DIR} modules
	@${MAKE} -j${JOBS} -C ${DIR} modules_install INSTALL_MOD_PATH=${ROOT}
	@${MAKE} -j${JOBS} -C ${DIR} headers_install INSTALL_HDR_PATH=${ROOT}
	@${MAKE} -j${JOBS} -C ${DIR} install INSTALL_PATH=${RELEASE_DIR} INSTALLKERNEL=${INSTALLKERNEL}
	cp -f ${DIR}/.config ${RELEASE_DIR}/config-${shell ${MAKE} -C ${DIR} kernelrelease | awk 'NR==2'}

.PHONY: clean
clean:
	@${MAKE} -j${JOBS} -C ${DIR} clean

${DIR}:
	@if [ ! -e "${PACKAGES}/${PKG}-${VER}.tar.gz" ]; then wget --directory-prefix=${PACKAGES} ${KERNELURL}/${PKG}-${VER}.tar.gz; fi
	@tar -xzf ${PACKAGES}/${PKG}-${VER}.tar.gz
	@if [ -e ${DEFAULT_CONFIG} ]; then cp ${DEFAULT_CONFIG} ${DIR}/.config; fi
	@if [ -n ${KERNEL_PATCH_LIST} ]; then cd ${DIR} && for p in ${KERNEL_PATCH_LIST}; do patch -p1 < $$p; done; fi
	@sed -i 's/# CONFIG_RD_LZMA is not set/CONFIG_RD_LZMA=y/g' ${DIR}/.config
	@echo "CONFIG_DECOMPRESS_LZMA=y" >> ${DIR}/.config
