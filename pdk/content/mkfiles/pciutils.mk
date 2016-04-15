.NOTPARALLEL:

include ${BASE}/.config

PKG:=pciutils
VERSION:=3.1.9
DIR:=${PKG}-${VERSION}

PCI_IDS=${LINUX_DIR}/embedded_rootfs/pci.ids

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} PREFIX=${ROOT} -C ${DIR} install
	rm -f ${ROOT}/usr/bin/lspci
	mkdir -p ${ROOT}/usr/local/share
	if [ -e ${PCI_IDS} ]; then cp -f ${PCI_IDS} ${ROOT}/usr/local/share/; \
		else mv ${ROOT}/share/pci.ids.gz ${ROOT}/usr/local/share/; fi

${DIR}:
	@tar -jxf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
