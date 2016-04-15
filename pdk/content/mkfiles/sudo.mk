.NOTPARALLEL:

include ${BASE}/.config

PKG:=sudo
VERSION:=1.8.12
DIR:=${PKG}-${VERSION}

SUDO_DEB_PACKAGE=sudo_1.8.12-1ubuntu3_amd64.deb
SUDOURL := http://security.ubuntu.com/ubuntu/pool/main/s/sudo

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	
.PHONY: install
install: 
	@dpkg-deb -X ${DIR}/${SUDO_DEB_PACKAGE} ${ROOT}


.PHONY: clean
clean:
	@rm -rf ${DIR}

${DIR}:
	@if [ ! -d ${DIR} ];then mkdir -p ${DIR}; wget --no-check-certificate -nv -O ${DIR}/${SUDO_DEB_PACKAGE} ${SUDOURL}/${SUDO_DEB_PACKAGE}; fi
