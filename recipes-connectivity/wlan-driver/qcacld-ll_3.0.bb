DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

inherit ${@bb.utils.contains('BASEMACHINE', '8x96auto', 'agl-wifi', '', d)}

inherit ${@bb.utils.contains('MACHINE', 'imx8mqevk', 'agl-wifi', '', d)}

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y CONFIG_ROME_IF=pci CONFIG_AR6320_SUPPORT=y CONFIG_QCA_CLD_WLAN_PROFILE=qca6174"
