.NOTPARALLEL:

-include ${BASE}/.config

.PHONY: all
all: build install

.PHONY: build
build:
	@echo "Creating bootable vBMC ISO"
	@mkdir -p ${LINUX_DIR}/root_iso/isolinux/
	@mkdir -p ${LINUX_DIR}/root_iso/images/
	@mkdir -p ${LINUX_DIR}/root_iso/kernel/
	@cp -f ${LINUX_DIR}/embedded_rootfs/pxe/pxelinux.cfg/default ${LINUX_DIR}/root_iso/isolinux/isolinux.cfg
	@cp -f ${LINUX_DIR}/embedded_rootfs/pxe/pxelinux.cfg/default ${LINUX_DIR}/root_iso/isolinux/syslinux.cfg
	@sed -i 's/vmlinuz-3.16.0/vmlinuz/g' ${LINUX_DIR}/root_iso/isolinux/isolinux.cfg
	@sed -i 's/ramfs.lzma/ramfs.lzm/g' ${LINUX_DIR}/root_iso/isolinux/isolinux.cfg
	@sed -i 's/vmlinuz-3.16.0/vmlinuz/g' ${LINUX_DIR}/root_iso/isolinux/syslinux.cfg
	@sed -i 's/IPAPPEND 3/ /g' ${LINUX_DIR}/root_iso/isolinux/syslinux.cfg
	@cp -f ${LINUX_DIR}/embedded_rootfs/pxe/ldlinux.c32 ${LINUX_DIR}/root_iso/isolinux/
	@cp -f ${LINUX_DIR}/embedded_rootfs/iso/isolinux.bin ${LINUX_DIR}/root_iso/isolinux/
	@cp ${RELEASE_DIR}/${KERNEL_OUT}* ${LINUX_DIR}/root_iso/isolinux/vmlinuz
	@cp ${RELEASE_DIR}/${INITRD_OUT}* ${LINUX_DIR}/root_iso/isolinux/ramfs.lzma
	@cp ${RELEASE_DIR}/${CONFIG_OUT}* ${LINUX_DIR}/root_iso/isolinux/config
	@cp ${RELEASE_DIR}/${SYSTEM_OUT}* ${LINUX_DIR}/root_iso/isolinux/system.map
	@cd ${LINUX_DIR} && mkisofs -o ${RELEASE_DIR}/vbmc.iso \
		-b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot \
		-boot-load-size 4 -input-charset utf-8 -boot-info-table root_iso/
	@echo "ISO ${RELEASE_DIR}/vbmc.iso is now ready"
	@cd ${RELEASE_DIR} && makensis -DRELEASEDIR="${RELEASE_DIR}" -DLINUXDIR="${LINUX_DIR}" ${LINUX_DIR}/embedded_rootfs/nsis/bootdisk.nsi
	@mv ${LINUX_DIR}/embedded_rootfs/nsis/bootdisk.exe ${RELEASE_DIR}

.PHONY: install
install:

.PHONY: clean
clean:
	@rm -fr ${LINUX_DIR}/root_iso/
