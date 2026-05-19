DESCRIPTION = "Qualcomm Technologies, Inc. WLAN CLD low latency driver version 3.2 for Congo"

inherit qcacld-30-common

WLAN_MODULE_NAME = "wlan-congo"

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"

DEPENDS += "virtual/kernel wlan-cnss-core"

EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=iq9075_gki_fig-v2 CHIP_NAME=fig MODNAME=${WLAN_MODULE_NAME}"
EXTRA_OEMAKE += "CONFIG_CNSS_SDIO=n CONFIG_CLD_HL_SDIO_CORE=n"
EXTRA_OEMAKE += "KBUILD_EXTRA=KBUILD_EXTRA_SYMBOLS=${STAGING_INCDIR}/wlan-cnss-core/Module.symvers"

do_install:append () {
    install -Dm0644 ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/updates/*.ko ${DEPLOY_DIR_IMAGE}/wlan/
}
