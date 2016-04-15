.NOTPARALLEL:

include ${BASE}/.config
PKG:=zlib
VERSION:=2.3.3
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_USE_ZLIB_DEB_PKG}, y)
    URL=${CONFIG_ZLIB_DEB_URL}
endif

LIB_DEB_PKG = zlib1g_1.2.3.3.dfsg-15ubuntu1_amd64.deb

.PHONY: all
all: build install

.PHONY: build
build:  ${DIR}
	# Compile source if there is any
	@if [ -z "${URL}" ]; then ${MAKE} -C ${DIR}; fi

.PHONY: install
install:
	# Extract the debian packages to the rootfs
	@if [ -n "${URL}" ]; then for pkg in ${LIB_DEB_PKG}; do echo "Installing $$pkg"; ar p ${DIR}/$$pkg data.tar.gz | tar xz -C ${ROOT}; done; fi

.PHONY: clean
clean:
	@rm -rf ${DIR}

${DIR}:
	# Download debian packages or attempt to extract source
	@if [ -n "${URL}" ]; then \
	    mkdir -p ${DIR}; for pkg in ${LIB_DEB_PKG}; do wget -nv -O ${DIR}/$$pkg ${URL}/$$pkg; done; \
	else tar -zxf ${PACKAGES}/${PKG}-${VERSION}.tar.gz; fi
