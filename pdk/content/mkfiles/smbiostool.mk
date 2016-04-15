.NOTPARALLEL:

include ${BASE}/.config

DIR:=tools

.PHONY: all

all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}/smbiostool

.PHONY: install
install:
	cp ${DIR}/smbiostool/smbiostool ${ROOT}/usr/bin


${DIR}:
	@echo "git clone tools into ${DIR}"
	@if [ ! -d ${DIR} ];then git clone --depth 1 -b master ${CONFIG_GIT_TOOLS_URL} ${DIR};fi
