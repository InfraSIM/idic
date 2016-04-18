.NOTPARALLEL:

include ${BASE}/.config

PKG:=socat
VERSION:=2.0.0-b8
DIR := ${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} -C ${DIR} install

${DIR}:
	tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	cd ${DIR} && ./configure --prefix=${ROOT}
