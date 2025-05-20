DESCRIPTION = "Qualcomm Technologies, Inc. WLAN CLD low latency driver version 3.2 for Rome"

inherit qcacld-30-common

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"
DEPENDS += "virtual/kernel"

WLAN_MODULE_NAME = "wlan-sdio"

EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=qca6174 CONFIG_CLD_HL_SDIO_CORE=y CONFIG_MULTI_IF_LOG=y"
EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y MODNAME=${WLAN_MODULE_NAME}"
