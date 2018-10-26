DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

inherit ${@base_conditional('MACHINE', '8x96connx', 'agl-wifi', '', d)}

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"
