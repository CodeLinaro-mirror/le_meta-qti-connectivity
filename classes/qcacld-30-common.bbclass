# WLAN driver qcacld basic bbclass for version 3.0.

inherit module kernel-arch

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

WLAN_MODULE_NAME ?= "wlan"
WLAN_CHIP_NAME ?= ""

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource:"
SRC_URI = "file://qcacld-3.0/ \
           file://qca-wifi-host-cmn/ \
           file://fw-api/ \
          "
S = "${WORKDIR}/qcacld-3.0"

FILES:${PN}     += "lib/firmware/*"
FILES:${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/${WLAN_MODULE_NAME}.ko"
RPROVIDES:${PN}  += "kernel-module-${WLAN_MODULE_NAME} kernel-module-${WLAN_MODULE_NAME}-${KERNEL_VERSION}"

EXTRA_OEMAKE += "CONFIG_WLAN_FEATURE_11W=y CONFIG_LINUX_QCMBR=y CONFIG_MULTI_IF_LOG=y"

do_compile:prepend() {
    sed -in '/Werror/d' ${S}/Kbuild
    # Using default qcacld-3.0 absolute path, get compilation error:
    # make[3]: execvp: /bin/sh: Argument list too long.
    # Becasue the Makefile argument including the objects files
    # paths is too long to complete the compilation.
    # Create soft link to the directory above KERNEL_SRC to fix this issue.
    # Need override the parameter M to use qcacld-3.0 relative path.
    # Need use wlan-cnss-core extra symbols when generating module.
    install -d ${STAGING_KERNEL_DIR}/../${PN}
    ln -sf ${WORKDIR}/qcacld-3.0 ${STAGING_KERNEL_DIR}/../${PN}/qcacld-3.0
    ln -sf ${WORKDIR}/qca-wifi-host-cmn ${STAGING_KERNEL_DIR}/../${PN}/qca-wifi-host-cmn
    ln -sf ${WORKDIR}/fw-api ${STAGING_KERNEL_DIR}/../${PN}/fw-api
    export M=../${PN}/qcacld-3.0
}

do_install () {
    export M=../${PN}/qcacld-3.0
    module_do_install
}
