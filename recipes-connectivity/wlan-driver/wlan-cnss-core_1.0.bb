# Hasting dependency modules compilation bb file

inherit module kernel-arch

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "${@oe.utils.version_less_or_equal('KERNELVERSION', '5.4', 'GPL-2.0', 'GPL-2.0-only', d)}"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource:"
SRC_URI = "file://wlan-cnss-core/"

S = "${WORKDIR}/wlan-cnss-core"

FILES:${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/wlan_cnss_core_pci.ko"

EXTRA_OEMAKE += "${@oe.utils.conditional('FEATURE_CNSS_STANDALONE', '1', 'full_tech=0', 'full_tech=1', d)}"

do_compile:prepend() {

# wlan hamilton driver need the two head files
    cp ${S}/inc/cnss2.h  ${STAGING_KERNEL_DIR}/include/net/
    cp ${S}/inc/cnss_utils.h ${STAGING_KERNEL_DIR}/include/net/
# head files at kernel is not updated, copy the latest files to kernel   
    cp ${S}/include/linux/mhi.h ${STAGING_KERNEL_DIR}/include/linux/mhi.h
    cp ${S}/include/linux/ipc_logging.h ${STAGING_KERNEL_DIR}/include/linux/ipc_logging.h
    cp ${S}/include/trace/events/qrtr.h ${STAGING_KERNEL_DIR}/include/trace/events/qrtr.h

    sed -in '/Werror/d' ${S}/Kbuild
}

do_install () {
    module_do_install
}
