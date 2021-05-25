DESCRIPTION = "Qualcomm Atheros WLAN CLD high latency driver version 2.0 for Rome"

inherit qcacld-20-common

WLAN_MODULE_NAME = "wlan-sdio"
CHIP_NAME = "${@bb.utils.contains('PROJECTID', 'QCA6584AULE201', 'qca6584', 'qca6174', d)}"

EXTRA_OEMAKE += "${@bb.utils.contains('PROJECTID', 'QCA6584AULE201', 'CONFIG_STATICALLY_ADD_11P_CHANNELS=y ', '', d)}"
EXTRA_OEMAKE += "CONFIG_CLD_HL_SDIO_CORE=y CONFIG_NON_QC_PLATFORM=y MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${CHIP_NAME}"
