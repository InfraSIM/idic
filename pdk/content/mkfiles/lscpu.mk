.NOTPARALLEL:

include ${BASE}/.config

PKG:=lscpu
VERSION:=1.8
DIR:=${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR} prefix=${ROOT}

.PHONY: install
install:
	mkdir -p ${ROOT}/usr/local/bin
	${MAKE} -C ${DIR} install prefix=${ROOT}

${DIR}:
	tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	cd ${DIR} && ./configure --prefix=${ROOT}
