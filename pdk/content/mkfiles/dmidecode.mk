.NOTPARALLEL:

include ${BASE}/.config

PKG:=dmidecode
VERSION:=2.12
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_PKG_dmidecode}, y)
	URL=${CONFIG_DMIDECODE_URL}
endif

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR} prefix=${ROOT}

.PHONY: install
install:
	${MAKE} -C ${DIR} install prefix=${ROOT}

${DIR}:
	@if [ ! -e ${PACKAGES}/${PKG}-${VERSION}.tar.bz2 ];then wget --no-check-certificate -nv -O ${PACKAGES}/${PKG}-${VERSION}.tar.bz2 ${URL}/${PKG}_${VERSION}.orig.tar.bz2; fi
	@tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
