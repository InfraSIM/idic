.NOTPARALLEL:

include ${BASE}/.config

PKG:=ipmitool
VERSION:=1.8.17
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
	@tar -xvjf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
	@cd ${DIR} && ./configure --prefix=${ROOT} --quiet
