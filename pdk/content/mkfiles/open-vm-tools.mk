.NOTPARALLEL:

include ${BASE}/.config
PKG:=open-vm-tools
VERSION:=10.0.7-3227872
DIR:=${PKG}-${VERSION}

OPENVMTOOLS_SRC_URL = http://security.ubuntu.com/ubuntu/pool/main/o/open-vm-tools
OPENVMTOOLS_SRC_PKG = open-vm-tools_${VERSION}.orig.tar.gz
OPENVMTOOLS_CONF_OPTS = --without-icu --without-x --without-gtk2 --without-gtkmm --without-kernel-modules --without-pam --without-procps --without-root-privileges --without-xerces --without-ssl --without-xmlsecurity --disable-deploypkg --disable-multimon --disable-tests

.PHONY: all
all: build install

.PHONY: build
build:  ${DIR}
	 ${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} -C ${DIR} install DESTDIR=${ROOT}

.PHONY: clean
clean:
	@rm -rf ${DIR}

${DIR}:
	@if [ ! -e "${PACKAGES}/${PKG}_${VERSION}.orig.tar.gz" ]; then wget --directory-prefix=${PACKAGES} ${OPENVMTOOLS_SRC_URL}/${PKG}_${VERSION}.orig.tar.gz; fi
	@tar -xvf ${PACKAGES}/${PKG}_${VERSION}.orig.tar.gz
	cd ${DIR} && autoreconf -i && ./configure --prefix=/usr ${OPENVMTOOLS_CONF_OPTS}


