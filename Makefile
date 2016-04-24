.NOTPARALLEL:

VNODE_DIR := vcompute
VPDU_DIR := vpdu

VNODE_TARGETS = $(filter-out common, $(shell find ${VNODE_DIR} -maxdepth 1 -type d -not -name ${VNODE_DIR} -exec basename {} \;))
VPDU_TARGETS = $(filter-out embedded_rootfs, $(shell find ${VPDU_DIR} -maxdepth 1 -type d -not -name ${VPDU_DIR} -exec basename {} \;))

MAKE := make

.DEFAULT: help

.PHONY: all
all: ${VNODE_TARGETS} ${VPDU_TARGETS}

define BUILD_TARGET
	@${MAKE} -C $1/$2
endef

#
# Build Targets
#
${VNODE_TARGETS}:
	$(call BUILD_TARGET, ${VNODE_DIR},$@)

${VPDU_TARGETS}:
	$(call BUILD_TARGET, ${VPDU_DIR},$@)

#
# function for menu config
# $1 - Node or PDU directory
# $2 - Target
# 
define MENUCONFIG
	@${MAKE} -C $1/$2 menuconfig
endef

menuconfig:
	$(if ${PDU},$(call MENUCONFIG,${VPDU_DIR},${PDU}),$(if ${NODE}, $(call MENUCONFIG,${VNODE_DIR},${NODE}),$(error "Please specify PDU or NODE.")))

ifneq ("$(wildcard /etc/lsb-release)", "")
-include /etc/lsb-release
DIST=${DISTRIB_ID}
endif

.PHONY: setupenv
setupenv:
	@if [ -e .envset ];then echo "Environment already setup."; fi
	@case ${DIST} in \
	Ubuntu) apt-get update -q; \
		apt-get install -y libncurses5 libncurses5-dev mkisofs zlib1g-dev \
		libglib2.0-dev autoconf pkg-config libtool libpopt-dev libssl-dev python-dev nsis \
		libdumbnet1 libdumbnet-dev python-dev python-setuptools bison flex tclsh bc docbook-to-man docbook-utils; \
		cp -f pdk/linux/embedded_rootfs/scripts/installkernel /sbin/installkernel-idic; ;; \
	*) echo "Unsupported platform"; ;; \
	esac
	@touch .envset
#
# function for clean signle target
# $1 - Node or PDU directory
# $2 - Target
# $3 - Action (clean/clean-root)
#
define CLEAN-SINGLE
	@${MAKE} -C $1/$2 $3
endef 

.PHONY: clean-single
clean-single:
	$(if ${NODE},$(call CLEAN-SINGLE,${VNODE_DIR},${NODE},clean),$(if ${PDU},$(call CLEAN-SINGLE,${VPDU_DIR},${PDU},clean),$(error "Please specify PDU or NODE.")))

.PHONY: clean-single-root
clean-single-root:
	$(if ${NODE},$(call CLEAN-SINGLE,${VNODE_DIR},${NODE},clean-root),$(if ${PDU},$(call CLEAN-SINGLE,${VPDU_DIR},${PDU},clean-root),$(error "Please specify PDU or NODE.")))

.PHONY: distclean-single
distclean-single:
	$(if ${NODE},$(call CLEAN-SINGLE,${VNODE_DIR},${NODE},distclean),$(if ${PDU},$(call CLEAN-SINGLE,${VPDU_DIR},${PDU},clean-root),$(error "Please specify PDU or NODE.")))


#
# $1 - Targets
# $2 - Target Dir
# $3 - Action (clean/clean-root)
#
define CLEAN
	@for sub in $1; do ${MAKE} -C $2/$$sub $3; done
endef 

#
# Clean all targets
# 
.PHONY: clean
clean:
	$(call CLEAN,${VNODE_TARGETS},${VNODE_DIR},clean)
	$(call CLEAN,${VPDU_TARGETS},${VPDU_DIR},clean)

.PHONY: clean-root
clean-root:
	$(call CLEAN,${VNODE_TARGETS},${VNODE_DIR},clean-root)
	$(call CLEAN,${VPDU_TARGETS},${VPDU_DIR},clean-root)

.PHONY: distclean
distclean:
	$(call CLEAN,${VNODE_TARGETS},${VNODE_DIR},distclean)
	$(call CLEAN,${VPDU_TARGETS},${VPDU_DIR},distclean)

.PHONY: help
help:
	@echo
	@echo "Build options: "
	@echo "	all                 - Build all virtual nodes and virtual PDUs packages (Quanta T41/D51, s2600kp, Sika, hawk, sentry)"
	@echo "	target              - target name"
	@echo "	clean               - Clean entire build environment"
	@echo "	clean-root          - Just clean embedded rootfs built packages untouched for all"
	@echo "	clean-single        - Clean build environment for one specified node/pdu"
	@echo "	clean-single-root   - Just clean rootfs built packages for one node/pdu"
	@echo 

