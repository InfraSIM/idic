.NOTPARALLEL:

include ${BASE}/.config
PKG:=valgrind
VERSION:=3.9.0
DIR:=${PKG}-${VERSION}

ifeq (${CONFIG_USE_VALGRIND_DEB_PKG}, y)
    URL=${CONFIG_VALGRIND_DEB_URL}
endif

LIB_DEB_PKG = libc6-dbg_2.11.1-0ubuntu7.2_amd64.deb  \
	      valgrind-3.9.0.deb

.PHONY: all
all: build install

.PHONY: build
build:  ${DIR}
	# Compile source if there is any
	@if [ -n "${URL}" ]; then ${MAKE} -C ${DIR}; fi

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
	fi
