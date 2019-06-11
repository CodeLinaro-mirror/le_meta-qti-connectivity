require  qcacld-20-common.inc

DESCRIPTION = "Qualcomm Atheros WLAN CLD low latency driver version 2.0"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/qcacld-2.0/ \
          "
S = "${WORKDIR}/wlan-opensource/qcacld-2.0"

#inherit autotools module kernel-arch
inherit module kernel-arch

FILES_${PN}     += "lib/firmware/wlan/*"
FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/wlan.ko"
PROVIDES_NAME    = "kernel-module-wlan"
RPROVIDES_${PN} += "${PROVIDES_NAME}"

EXTRA_OEMAKE += "CONFIG_NON_QC_PLATFORM=y CONFIG_WLAN_FEATURE_11W=y CONFIG_LINUX_QCMBR=y CONFIG_NON_QC_PLATFORM=y"

do_install () {

     module_do_install

     install -d ${D}/lib/firmware/wlan/
     install -m 644 ${S}/firmware_bin/WCNSS_cfg.dat ${D}/lib/firmware/wlan/cfg.dat
}
