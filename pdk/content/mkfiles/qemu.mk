.NOTPARALLEL:

include ${BASE}/.config

PKG:=qemu
VERSION:=stable-2.2-ipmi
DIR:=${PKG}-${VERSION}
BRANCH:=stable-2.2-ipmi

ifeq (${CONFIG_ARCH}, "")
${error "No CPU architecture specified"}
endif

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	${MAKE} -j${JOBS} -C ${DIR}

.PHONY: install
install:
	${MAKE} -C ${DIR} install DESTDIR=${ROOT}

${DIR}:
	@echo "git clone qemu into ${DIR}"
	@if [ ! -d ${DIR} ];then \
		bash -c "git clone --depth 1 -b ${BRANCH} ${CONFIG_GIT_QEMU_URL} ${DIR}; \
		pushd ${DIR};\
		git submodule update --init pixman dtc;\
		popd"; \
	fi;
	@echo "configure qemu"
	@cd ${DIR} && ./configure --target-list="${CONFIG_ARCH}-linux-user ${CONFIG_ARCH}-softmmu" --prefix=/usr --disable-smartcard-nss --disable-seccomp --disable-glusterfs --disable-tpm --disable-vhdx --disable-bluez --disable-fdt --disable-gtk --disable-cocoa --disable-sdl --without-system-pixman