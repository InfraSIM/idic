.NOTPARALLEL:

-include ${BASE}/.config

.PHONY: all
all: build install

.PHONY: build
build:
	@echo "Creating bootable USB on ${USBDEV}"
	@if [ ! "${USBDEV}" ]; then echo "USB storage device required, ie /dev/sdb"; exit 1; fi
	@if [ "${shell mount | grep -c ${USBDEV}1}" -eq "1" ]; then sudo umount ${USBDEV}1; fi
	@sh ${SCRIPTS}/bootpart.sh ${USBDEV} ${USBSIZE} > /dev/null
	@mke2fs ${USBDEV}1
	@mkdir -p ${LINUX_DIR}/usb
	@mount ${USBDEV}1 ${LINUX_DIR}/usb
	@${ROOT}/sbin/grub-install --no-floppy --root-directory=${LINUX_DIR}/usb ${USBDEV}
	@rm -f ${LINUX_DIR}/usb/boot/grub/fat_stage1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/ffs_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/iso9660_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/jfs_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/minix_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/reiserfs_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/ufs2_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/vstatfs_stage_1_5
	@rm -f ${LINUX_DIR}/usb/boot/grub/xfs_stage_1_5
	@cp ${LINUX_DIR}/embedded_rootfs/usb/grub.conf ${LINUX_DIR}/usb/boot/grub/
	@cd ${LINUX_DIR}/usb/boot/grub/ && ln -s grub.conf menu.lst
	@cp ${RELEASE_DIR}/${KERNEL_OUT}* ${LINUX_DIR}/usb/
	@cp ${RELEASE_DIR}/${INITRD_OUT}* ${LINUX_DIR}/usb/
	@cp ${RELEASE_DIR}/${CONFIG_OUT}* ${LINUX_DIR}/usb/
	@cp ${RELEASE_DIR}/${SYSTEM_OUT}* ${LINUX_DIR}/usb/
	@umount ${USBDEV}1
	@echo "USB ${USBDEV} is now ready"

.PHONY: install
install:

.PHONY: clean
clean:
