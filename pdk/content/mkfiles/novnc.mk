.NOTPARALLEL:

include ${BASE}/.config

PKG:=novnc
VERSION:=0.4
DIR:=${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}

.PHONY: install
install:
	@mkdir -p ${ROOT}/usr/local/bin
	@cp -rf ${DIR} ${ROOT}/usr/local/bin

${DIR}:
	@tar -jxf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
