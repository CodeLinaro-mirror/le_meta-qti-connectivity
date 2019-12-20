# WLAN driver qcacld basic bbclass.

inherit module kernel-arch

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

WLAN_MODULE_NAME ?= "wlan"
WLAN_CHIP_NAME ?= ""

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource:"
SRC_URI = "file://qcacld-${PV}/"
SRC_URI += "${@bb.utils.contains('PV', '3.0', ' file://qca-wifi-host-cmn/', '', d)}"
SRC_URI += "${@bb.utils.contains('PV', '3.0', ' file://fw-api/', '', d)}"

S = "${WORKDIR}/qcacld-${PV}"

FILES_${PN}     += "lib/firmware/*"
FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/${WLAN_MODULE_NAME}.ko"
RPROVIDES_${PN}  += "kernel-module-${WLAN_MODULE_NAME} kernel-module-${WLAN_MODULE_NAME}-${KERNEL_VERSION}"

EXTRA_OEMAKE += "CONFIG_WLAN_FEATURE_11W=y CONFIG_LINUX_QCMBR=y PANIC_ON_BUG=n"

do_compile_prepend() {
    sed -in '/Werror/d' ${S}/Kbuild
}

do_install () {
    module_do_install
}
