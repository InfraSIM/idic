.NOTPARALLEL:

include ${BASE}/.config

COMMON:=${BASE}/../common
IPMI_SIM:=${COMMON}/scripts/ipmi_sim
DST_DIR:=${ROOT}/etc/ipmi/util

.PHONY: all
all: install

.PHONY: install
install:
	@echo "install ipmi sim"
	if [ ! -d "${DST_DIR}" ]; then mkdir -p ${DST_DIR}; fi
	if [ -d "${IPMI_SIM}" ]; then cp ${IPMI_SIM}/*.py ${DST_DIR}; fi
	chmod 755 ${DST_DIR}/*.py
	if [ -d "${IPMI_SIM}" ]; then cp ${IPMI_SIM}/README ${DST_DIR}; fi
	if [ -d "${IPMI_SIM}" ]; then cp -r ${IPMI_SIM}/modules ${DST_DIR}; fi

.PHONY: clean
clean:
	@echo clean up
	if [ -d "${DST_DIR}" ]; then rm -rf ${DST_DIR}; fi
