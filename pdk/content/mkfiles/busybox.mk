.NOTPARALLEL:

include ${BASE}/.config

PKG:=busybox
VERSION:=1.23.2
DIR:=${PKG}-${VERSION}
LINKS=`xargs < ${DIR}/busybox.links`

SBINSCRIPTS:=boardinfo history service shutdown

ifeq (${CONFIG_USE_BUSYBOX_SOURCE}, y)
BUSYBOXURL = ${CONFIG_BUSYBOX_URL}
endif

.PHONY: all
all: build install

.PHONY: build
build: ${DIR}
	@${MAKE} -j${JOBS} -C ${DIR}
	@${MAKE} -C ${BUILD} -f ${MKFILES}/devices.mk

.PHONY: install
install:
	mkdir -p ${ROOT}/bin
	mkdir -p ${ROOT}/sbin
	mkdir -p ${ROOT}/usr/bin
	mkdir -p ${ROOT}/usr/sbin
	mkdir -p ${ROOT}/proc
	mkdir -p ${ROOT}/sys
	mkdir -p ${ROOT}/mnt
	mkdir -p ${ROOT}/tmp
	mkdir -p ${ROOT}/mnt
	mkdir -p ${ROOT}/var/log
	mkdir -p ${ROOT}/etc
	mkdir -p ${ROOT}/root
	mkdir -p ${ROOT}/boot
	mkdir -p ${ROOT}/home
	mkdir -p ${ROOT}/dev
	${MAKE} CONFIG_PREFIX=${ROOT} -j${JOBS} -C ${DIR} install
	ln -fs /lib ${ROOT}/lib64
	ln -fs /sbin/init ${ROOT}/init
	ln -fs /etc/rc ${ROOT}/sbin/rc
	ln -fs /etc/rc.shutdown ${ROOT}/sbin/rc.shutdown
	cp -rf ${INITDIR} ${ROOT}/etc/
	cp -rf ${CONFDIR}/* ${ROOT}/etc/
	cp -rf ${ETCDIR}/fstab ${ROOT}/etc/
	cp -rf ${ETCDIR}/group ${ROOT}/etc/
	cp -rf ${ETCDIR}/inittab ${ROOT}/etc/
	cp -rf ${ETCDIR}/network ${ROOT}/etc/
	cp -rf ${ETCDIR}/network/* ${ROOT}/etc/network/
	cp -rf ${ETCDIR}/passwd ${ROOT}/etc/
	cp -rf ${ETCDIR}/protocols ${ROOT}/etc/
	cp -rf ${ETCDIR}/rc.local ${ROOT}/etc/
	cp -rf ${ETCDIR}/shadow ${ROOT}/etc/
	cp -rf ${ETCDIR}/hosts ${ROOT}/etc/
	echo "${CONFIG_HOSTNAME}" > ${ROOT}/etc/hostname
	cp -rf ${ETCDIR}/host.conf ${ROOT}/etc/
	cp -rf ${ETCDIR}/nsswitch.conf ${ROOT}/etc/
	cp -rf ${ETCDIR}/issue ${ROOT}/etc/
	mkdir -p ${ROOT}/etc/ssh
	mkdir -p ${ROOT}/etc/default
	cp -rf ${ETCDIR}/ssh/moduli ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_config ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/sshd_config ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_dsa_key ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_dsa_key.pub ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_key ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_key.pub ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_rsa_key ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/ssh_host_rsa_key.pub ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/ssh/authorized_keys ${ROOT}/etc/ssh
	cp -rf ${ETCDIR}/pam.conf ${ROOT}/etc
	cp -rf ${ETCDIR}/pam.d ${ROOT}/etc
	ln -fs /proc/mounts ${ROOT}/etc/mtab
	mkdir -p ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.script ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.renew ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.nak ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.leasefail ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.deconfig ${ROOT}/usr/share/udhcpc/
	cp ${ETCDIR}/udhcpc.bound ${ROOT}/usr/share/udhcpc/
	ln -fs udhcpc.script ${ROOT}/usr/share/udhcpc/default.script
	cp ${ETCDIR}/udhcpd.conf ${ROOT}/etc/
	mkdir -p ${ROOT}/var/run
	mkdir -p ${ROOT}/var/lib/misc
	touch ${ROOT}/var/lib/misc/udhcpd.leases
	cp -f ${ETCDIR}/profile ${ROOT}/etc/
	cp -f ${ETCDIR}/bashrc ${ROOT}/etc/
	if [ -n "${CONFIG_NFS}" ]; then echo "${CONFIG_NFS_REMOTE} ${CONFIG_NFS_MNT_PNT} nfs nolock 0 0" >> ${ROOT}/etc/fstab; fi
	for s in ${SBINSCRIPTS}; do cp -f ${SCRIPTS}/$$s /${ROOT}/sbin/; done
	cp -f ${LINUX_DIR}/embedded_rootfs/rc ${ROOT}/etc/
	cp -f ${LINUX_DIR}/embedded_rootfs/rc.shutdown ${ROOT}/etc/
	cp -f ${LINUX_DIR}/embedded_rootfs/modules.load ${ROOT}/etc/
	cp -f ${LINUX_DIR}/embedded_rootfs/modules ${ROOT}/etc/
	cp -rf ${ETCDIR}/default ${ROOT}/etc

${DIR}:
	@if [ ! -e "${PACKAGES}/${PKG}-${VERSION}.tar.bz2" ];then wget --no-check-certificate -nv -O ${PACKAGES}/${PKG}-${VERSION}.tar.bz2 ${BUSYBOXURL}/${PKG}-${VERSION}.tar.bz2; fi
	@tar -jxf ${PACKAGES}/${PKG}-${VERSION}.tar.bz2
	@cp ${LINUX_DIR}/embedded_rootfs/busybox/busybox.config-${VERSION} ${DIR}/.config
