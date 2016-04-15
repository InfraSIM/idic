.NOTPARALLEL:

include ${BASE}/.config

DIR := vpduserv

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}

.PHONY: install
install: 
	@echo "Install vPDU service"
	@cd ${DIR} && python setup.py install --root=${ROOT} --prefix=/usr --install-data=/usr --install-lib=/usr/lib/python2.7/dist-packages

${DIR}:
	@echo "clone vpdu service to ${DIR}"
	@if [ ! -d ${DIR} ];then git clone --depth 1 -b master ${CONFIG_GIT_VPDU_URL} ${DIR};fi
