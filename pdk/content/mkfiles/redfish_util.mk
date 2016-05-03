.NOTPARALLEL:

include ${BASE}/.config

COMMON:=${BASE}/../common
REDFISH:=${COMMON}/scripts/redfish
DST_DIR:=${ROOT}/etc/redfish

.PHONY: all
all: install

.PHONY: install
install:
	@echo "install redfish"
	if [ ! -d "${DST_DIR}" ]; then mkdir -p ${DST_DIR}; fi
	if [ -d "${REDFISH}" ]; then cp -rap ${REDFISH}/* ${DST_DIR}/; fi

.PHONY: clean
clean:
	@echo clean up
	if [ -d "${DST_DIR}" ]; then rm -rf ${DST_DIR}; fi
