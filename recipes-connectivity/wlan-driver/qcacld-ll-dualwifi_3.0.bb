DESCRIPTION = "wifi drivers qcacld-3.2 for dual wifi support"

inherit qcacld

WLAN_MODULE_NAME = "wlan-dual-wifi"
WLAN_CHIP_NAME   = "dual-wifi"

inherit ${@base_conditional('BASEMACHINE', '8x96auto', 'agl-wifi', '', d)}

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"
EXTRA_OEMAKE += "MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${WLAN_CHIP_NAME}"
