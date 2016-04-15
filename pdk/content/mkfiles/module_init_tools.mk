.NOTPARALLEL:

include ${BASE}/.config

PKG:=module-init-tools
VERSION:=3.9
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
	@tar -jxf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
	@cd ${DIR} && ./configure --quiet --prefix=${ROOT}
