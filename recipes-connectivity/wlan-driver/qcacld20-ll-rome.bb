DESCRIPTION = "Qualcomm Atheros WLAN CLD low latency driver version 2.0 for Rome"

inherit qcacld-20-common

EXTRA_OEMAKE += "CONFIG_NON_QC_PLATFORM=y"
