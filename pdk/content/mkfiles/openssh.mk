.NOTPARALLEL:

include ${BASE}/.config

PKG:=openssh
VERSION:=5.4p1
DIR:=${PKG}-${VERSION}

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR} SSH_PROGRAM=/bin/ssh

.PHONY: install
install:
	${MAKE} -C ${DIR} install

${DIR}:
	tar -zxf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	cd ${DIR} && ./configure --quiet --prefix=${ROOT} --sysconfdir=${ROOT}/etc/ssh --with-privsep-path=${ROOT}/var/empty
