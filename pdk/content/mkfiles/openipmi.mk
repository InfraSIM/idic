.NOTPARALLEL:

include ${BASE}/.config

PKG:=OpenIPMI
VERSION:=master
DIR:=${PKG}-${VERSION}
BRANCH:=infrasim-openipmi-2.0.22

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} -C ${DIR} install

${DIR}:
	@echo "git clone OpenIPMI into ${DIR}"
	@if [ ! -d ${DIR} ];then \
		bash -c "git clone --depth 1 -b ${BRANCH} ${CONFIG_GIT_OPENIPMI_URL} ${DIR}"; \
	fi;
	@echo "configure openipmi"
	@cd ${DIR} && autoreconf -i && ./configure CFLAGS="-lrt -lpthread" --prefix=${ROOT} --with-tcl=no
