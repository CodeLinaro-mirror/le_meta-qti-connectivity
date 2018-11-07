#QTI AGL BSP specific wlan driver bbclass
inherit signature qperf

DUAL_WIFI = "${@d.getVar('PN', True) == 'qcacld-ll-dualwifi'}"
WLAN_MODULE_NAME = "${@base_conditional('DUAL_WIFI', 'True', 'wlan-cnss2', 'wlan-cnss0', d)}"
WLAN_CHIP_NAME   = "${@base_conditional('DUAL_WIFI', 'True', 'rome-cnss2', 'rome-cnss0', d)}"

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"

EXTRA_OEMAKE += "MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${WLAN_CHIP_NAME}"
