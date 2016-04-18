.NOTPARALLEL:

include ${BASE}/.config

PKG:=hdparm
VERSION:=9.43
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_PKG_hdparm}, y)
	URL=${CONFIG_HDPARM_URL}
endif

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}  binprefix=${ROOT} manprefix=${ROOT}/usr

.PHONY: install
install:
	${MAKE} -C ${DIR} install  binprefix=${ROOT} manprefix=${ROOT}/usr

${DIR}:
	@if [ ! -e ${PACKAGES}/${PKG}-${VERSION}.tar.gz ];then wget --no-check-certificate -nv -O ${PACKAGES}/${PKG}-${VERSION}.tar.gz ${URL}/${PKG}_${VERSION}.orig.tar.gz; fi
	@tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	cd ${DIR}
