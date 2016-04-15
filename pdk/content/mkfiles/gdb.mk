.NOTPARALLEL:

include ${BASE}/.config

PKG:=gdb
VERSION:=7.7
DIR:=${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} -C ${DIR} install

${DIR}:
	tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
	cd ${DIR} && ./configure  --prefix=${ROOT}
