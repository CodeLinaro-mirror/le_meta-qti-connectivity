require  qcacld-20-common.inc

DESCRIPTION = "Qualcomm Atheros WLAN CLD high latency driver version 2.0"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/qcacld-2.0/ \
          "
S = "${WORKDIR}/wlan-opensource/qcacld-2.0"

#inherit autotools module kernel-arch
inherit module kernel-arch

WLAN_MODULE_NAME = "wlan-sdio"
CHIP_NAME = "${@bb.utils.contains('PROJECTID', 'QCA6584AULE201', 'qca6584', 'qca6574', d)}"

FILES_${PN}     += "lib/firmware/wlan/*"
FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/${WLAN_MODULE_NAME}.ko"
RPROVIDES_${PN} += "kernel-module-${WLAN_MODULE_NAME} kernel-module-${WLAN_MODULE_NAME}-${KERNEL_VERSION}"

FIRMWARE_CFG_PATH = "${D}${base_libdir}/firmware/wlan/${CHIP_NAME}"

EXTRA_OEMAKE += "${@bb.utils.contains('PROJECTID', 'QCA6584AULE201', 'CONFIG_STATICALLY_ADD_11P_CHANNELS=y ', '', d)}"

EXTRA_OEMAKE += "CONFIG_CLD_HL_SDIO_CORE=y CONFIG_WLAN_FEATURE_11W=y CONFIG_LINUX_QCMBR=y CONFIG_NON_QC_PLATFORM=y MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${CHIP_NAME}"

do_install () {

     module_do_install
     install -d ${FIRMWARE_CFG_PATH}
     install -m 644 ${S}/firmware_bin/WCNSS_cfg.dat ${FIRMWARE_CFG_PATH}/cfg.dat
}

