.NOTPARALLEL:

include ${BASE}/.config

PKG:=sqlite3
VERSION:= 3.8.7.4
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_PKG_sqlite3}, y)
	URL=${CONFIG_SQLITE3_URL}
endif

.PHONY:all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR} sqlite3.c

.PHONY: install
install:
	${MAKE} -C ${DIR} install DESTDIR=${ROOT}

${DIR}:
	@if [ ! -e ${PACKAGES}/${PKG}-${VERSION}.tar.bz2 ];then wget --no-check-certificate -nv -O ${PACKAGES}/${PKG}-${VERSION}.tar.bz2 ${URL}/${PKG}_${VERSION}.orig.tar.bz2; fi
	tar -xvf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
	cd ${DIR} && ./configure --disable-tcl --enable-load-extension --prefix=/usr
