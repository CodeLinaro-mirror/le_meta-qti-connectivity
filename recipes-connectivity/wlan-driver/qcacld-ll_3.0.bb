DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

inherit ${@base_conditional('BASEMACHINE', '8x96auto', 'agl-wifi', '', d)}

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"
