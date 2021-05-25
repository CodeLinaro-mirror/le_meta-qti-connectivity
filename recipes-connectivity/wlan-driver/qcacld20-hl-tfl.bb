DESCRIPTION = "Qualcomm Atheros WLAN CLD high latency driver version 2.0 for tufello"

inherit qcacld-20-common

WLAN_MODULE_NAME = "wlan-sdio"
CHIP_NAME = "qca9377"

EXTRA_OEMAKE += "CONFIG_CLD_HL_SDIO_CORE=y CONFIG_NON_QC_PLATFORM=y MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${CHIP_NAME}"
