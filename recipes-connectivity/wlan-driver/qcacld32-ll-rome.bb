DESCRIPTION = "Qualcomm Technologies, Inc. WLAN CLD low latency driver version 3.2 for Rome"

inherit qcacld-30-common

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"
DEPENDS += "virtual/kernel"
EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=qca6174 CONFIG_ROME_IF=pci"
EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y"
#EXTRA_OEMAKE += "CONFIG_FEATURE_SINGLE_MSI=y"
