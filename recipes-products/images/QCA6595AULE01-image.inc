DESCRIPTION = "QCA6595AU.LE.0.1 Standalone BSP required images"

IMAGE_INSTALL += "pciutils"

IMAGE_INSTALL += "iputils"

IMAGE_INSTALL += "bridge-utils"

#IMAGE_INSTALL += "qcacld-ll"

#IMAGE_INSTALL += "qcacld-hl-tfl"

IMAGE_INSTALL += "qcacld-ll-rome"
IMAGE_INSTALL += "qcacld-ll-genoa"
IMAGE_INSTALL += "qcacld-ll-hasting"