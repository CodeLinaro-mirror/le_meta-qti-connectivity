DESCRIPTION = "QTI WLAN CNSS CORE driver"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/wlan-cnss-core/ \
          "
S = "${WORKDIR}/wlan-opensource/wlan-cnss-core"

#inherit autotools module kernel-arch
inherit module kernel-arch

FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/wlan-cnss-core-pcie.ko"
PROVIDES_NAME    = "kernel-module-wlan-cnss-core"
RPROVIDES_${PN} += "${PROVIDES_NAME}"



do_install () {
     module_do_install
}
