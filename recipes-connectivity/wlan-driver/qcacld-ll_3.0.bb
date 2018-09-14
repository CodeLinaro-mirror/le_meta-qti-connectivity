DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

inherit ${@base_conditional('MACHINE', '8x96connx', 'agl-wifi', '', d)}

S_STRIPPED = "${WORKDIR}/packages-split/kernel-module-${WLAN_MODULE_NAME}/lib/modules/${KERNEL_VERSION}/extra"

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y CONFIG_WLAN_DFS_MASTER_ENABLE=n"
