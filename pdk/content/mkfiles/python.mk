.NOTPARALLEL:

include ${BASE}/.config
PKG:=python
VERSION:=2.7.6-8
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_USE_PYTHON_DEB_PKG}, y)
    URL=${CONFIG_PYTHON_DEB_URL}
endif

LIB_DEB_PKG = libpython2.7_${VERSION}_amd64.deb \
			  libpython2.7-dev_${VERSION}_amd64.deb \
			  libpython2.7-minimal_${VERSION}_amd64.deb \
			  libpython2.7-stdlib_${VERSION}_amd64.deb \
			  python2.7_${VERSION}_amd64.deb \
			  python2.7-dev_${VERSION}_amd64.deb \
			  python2.7-minimal_${VERSION}_amd64.deb


.PHONY: all
all: build install

.PHONY: build
build:  ${DIR}
	# Compile source if there is any
	@if [ -z "${URL}" ]; then ${MAKE} -C ${DIR}; fi

.PHONY: install
install:
	# Extract the debian packages to the rootfs
	@if [ -n "${URL}" ]; then for pkg in ${LIB_DEB_PKG}; do echo "Installing $$pkg"; dpkg-deb -X ${DIR}/$$pkg ${ROOT}; done; fi
	cd ${ROOT}/usr/bin && ln -s /usr/bin/python2.7 python

.PHONY: clean
clean:
	@rm -rf ${DIR}

${DIR}:
	# Download debian packages or attempt to extract source
	@if [ -n "${URL}" ]; then \
	    mkdir -p ${DIR}; for pkg in ${LIB_DEB_PKG}; do wget -nv -O ${DIR}/$$pkg ${URL}/$$pkg; done; \
	else tar -zxf ${PACKAGES}/${PKG}-${VERSION}.tar.gz; fi
