.NOTPARALLEL:

include ${BASE}/.config

PKG:=iproute2
VERSION:=4.3.0
DIR:=${PKG}-${VERSION}
URL:=https://www.kernel.org/pub/linux/utils/net/iproute2
.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR} 

.PHONY: install
install:
	${MAKE} -C ${DIR} install DESTDIR=${ROOT} CONFDIR=/etc/iproute2

${DIR}:
	if [ ! -e ${PACKAGES}/${PKG}-${VERSION}.tar.gz ];then wget --no-check-certificate --directory-prefix=${PACKAGES} ${URL}/${PKG}-${VERSION}.tar.gz; fi
	@tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.gz
	@cd ${DIR}
