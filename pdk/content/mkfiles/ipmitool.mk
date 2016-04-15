.NOTPARALLEL:

include ${BASE}/.config

PKG:=ipmitool
VERSION:=1.8.13
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
	@tar -zxf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	@cd ${DIR} && ./configure --prefix=${ROOT} --quiet
