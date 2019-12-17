DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

inherit ${@bb.utils.contains('BASEMACHINE', '8x96auto', 'agl-wifi', '', d)}

inherit ${@bb.utils.contains('MACHINE', 'imx8mqevk', 'agl-wifi', '', d)}

EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"

EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=genoa.pci.debug" 


SINGLE_CHIP_NAME = "qcn7605"
WLAN_MODULE_NAME = "wlan-genoa-pcie"

EXTRA_OEMAKE += "CONFIG_CNSS2=y CONFIG_IPA_DISABLE_OVERRIDE=y"
EXTRA_OEMAKE += "MODNAME=${WLAN_MODULE_NAME}"
EXTRA_OEMAKE += "DYNAMIC_SINGLE_CHIP=${SINGLE_CHIP_NAME}"

