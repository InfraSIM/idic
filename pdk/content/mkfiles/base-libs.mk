.NOTPARALLEL:

include ${BASE}/.config

PKG:=${CONFIG_BASE_LIB}
VERSION:=1.2
DIR:=${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}

.PHONY: install
install:
	cp -rf ${DIR}/* ${ROOT} 

${DIR}:
	@tar -jxf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
