DESCRIPTION = "QTI WLAN CNSS CORE driver"
inherit module kernel-arch
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=801f80980d171dd6425610833a22dbe6"

DEPENDS = "virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/wlan-cnss-core/ \
          "
S = "${WORKDIR}/wlan-opensource/wlan-cnss-core"


FILES_${PN}     += "${base_libdir}/modules/${KERNEL_VERSION}/extra/wlan-cnss-core-pcie.ko"
PROVIDES_NAME    = "kernel-module-wlan-cnss-core"
RPROVIDES_${PN} += "${PROVIDES_NAME}"

#EXTRA_OEMAKE += "CONFIG_WLAN_EN=y" 
#EXTRA_OEMAKE += "CONFIG_PCI_RC_SUPPORT_PM=y" 
#EXTRA_OEMAKE += "CONFIG_ONE_MSI_VECTOR=y" 
EXTRA_OEMAKE += "${@oe.utils.conditional('FEATURE_SINGLE_MSI', '1', 'CONFIG_ONE_MSI_VECTOR=y', '', d)}"

do_compile_prepend() {
    sed -in '/Werror/d' ${S}/Kbuild
}


do_install () {
     module_do_install
}
