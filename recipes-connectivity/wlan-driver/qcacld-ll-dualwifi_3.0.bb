DESCRIPTION = "wifi drivers qcacld-3.2 for dual wifi support"

inherit qcacld

WLAN_MODULE_NAME = "wlan-dual-wifi"
WLAN_CHIP_NAME   = "dual-wifi"

inherit ${@base_conditional('MACHINE', '8x96connx', 'agl-wifi', '', d)}

S_STRIPPED = "${WORKDIR}/packages-split/kernel-module-${WLAN_MODULE_NAME}/lib/modules/${KERNEL_VERSION}/extra"

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"
EXTRA_OEMAKE += "MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${WLAN_CHIP_NAME}"
