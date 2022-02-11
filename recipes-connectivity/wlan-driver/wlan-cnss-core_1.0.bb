# Hasting dependency modules compilation bb file

inherit module kernel-arch

PACKAGE_ARCH = "${MACHINE_ARCH}"

LICENSE = "${@oe.utils.version_less_or_equal('KERNELVERSION', '5.4', 'GPL-2.0', 'GPL-2.0-only', d)}"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource:"
SRC_URI = "file://wlan-cnss-core/"

S = "${WORKDIR}/wlan-cnss-core"

FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/wlan_cnss_core_pci.ko"

do_compile_prepend() {

# wlan hasting driver need the two head files
    cp ${S}/cnss2/cnss2.h  ${STAGING_KERNEL_DIR}/include/net/
    cp ${S}/cnss_utils/cnss_utils.h ${STAGING_KERNEL_DIR}/include/net/

    sed -in '/Werror/d' ${S}/Kbuild
}

do_install () {
    module_do_install
}
