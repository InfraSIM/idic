.NOTPARALLEL:

include ${BASE}/.config

DIR := redfishsim

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}

.PHONY: install
install: 
	@echo "Install redfish simulator service"
	@cd ${DIR} && python setup.py install --root=${ROOT} --prefix=/usr --install-data=/usr --install-lib=/usr/lib/python2.7/dist-packages 

${DIR}:
	@echo "clone redfish simulator to ${DIR}"
	@if [ ! -d ${DIR} ];then git clone --depth 1 -b master ${CONFIG_GIT_REDFISHSIM_URL} ${DIR};fi
