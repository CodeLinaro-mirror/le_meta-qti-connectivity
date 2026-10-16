DESCRIPTION = "Qualcomm Technologies, Inc. WLAN CLD low latency driver version 3.2 for Congo"

inherit qcacld-30-common

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:iq-9075-evk = "(.*)"

WLAN_MODULE_NAME = "wlan-congo"

SRC_URI += " \
    file://iq9075_gki_qca_fig-v2_defconfig \
    file://0001-qcacld-3.0-Fix-compiling-issue-for-kernel-6.18.21.patch \
"

DEPENDS += "wlan-cnss-core"
RDEPENDS:${PN} += "wlan-cnss-core qca-congo-config"

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"

EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=iq9075_gki_qca_fig-v2 CHIP_NAME=fig_v2 MODNAME=${WLAN_MODULE_NAME}"
EXTRA_OEMAKE += "CONFIG_CNSS_SDIO=n CONFIG_CLD_HL_SDIO_CORE=n"
EXTRA_OEMAKE += "KBUILD_EXTRA=KBUILD_EXTRA_SYMBOLS=${STAGING_INCDIR}/wlan-cnss-core/Module.symvers"
EXTRA_OEMAKE += "WLAN_PLATFORM_INC=${STAGING_INCDIR}/wlan-cnss-core"
EXTRA_OEMAKE += "KCFLAGS='-DQLI_2_0_QCACLD'"

do_configure:prepend() {
    cp ${UNPACKDIR}/iq9075_gki_qca_fig-v2_defconfig ${S}/configs/iq9075_gki_qca_fig-v2_defconfig
}

do_install:append() {
    install -Dm0644 ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/updates/*.ko ${DEPLOY_DIR_IMAGE}/wlan/
}
