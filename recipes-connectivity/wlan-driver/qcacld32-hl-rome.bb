DESCRIPTION = "wifi drivers qcacld-3.2"

inherit qcacld

WLAN_MODULE_NAME = "wlan-sdio"
CHIP_NAME = "qca6574"

SRC_URI = "file://qcacld-3.0/"
SRC_URI += "file://qca-wifi-host-cmn/"
SRC_URI += "file://fw-api/"

S = "${WORKDIR}/qcacld-3.0"

EXTRA_OEMAKE += "CONFIG_WLAN_FEATURE_11W=y CONFIG_LINUX_QCMBR=y PANIC_ON_BUG=n"
EXTRA_OEMAKE += "CONFIG_CLD_HL_SDIO_CORE=y MODNAME=${WLAN_MODULE_NAME} CHIP_NAME=${CHIP_NAME}"
