#Standalone Automotive image BBFILE for iMX8 platform
#The project specific tasks needs to be added in specific
#project related include file, ${PROJECTID}-image.inc file.

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

inherit core-image
require recipes-products/images/standalone-imx8auto-image-prop.bb

IMAGE_ROOTFS_SIZE ?= "557056"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

#Common required tools
IMAGE_INSTALL += "iw"
IMAGE_INSTALL += "tcpdump"
IMAGE_INSTALL += "wireless-tools"
IMAGE_INSTALL += "iperf2"
IMAGE_INSTALL += "iperf3"
IMAGE_INSTALL += "pciutils"
IMAGE_INSTALL += "iputils"
IMAGE_INSTALL += "bridge-utils"
IMAGE_INSTALL += "openssh"
IMAGE_INSTALL += "packagegroup-core-ssh-openssh"
IMAGE_INSTALL += "openssh-sftp-server"
IMAGE_INSTALL += "iptables"
IMAGE_INSTALL += "boost"
IMAGE_INSTALL += "vsomeip"
IMAGE_INSTALL += "android-common-libs"
IMAGE_INSTALL += "protobuf"
IMAGE_INSTALL += "hardware-legacy-headers cld80211-lib wifi-hal-qcom wifi-hal-lib"
IMAGE_INSTALL += "wifi-cond-nlmsg-proto wifi-cond-nlmsg-message"

#Bluetooth software
SYNERGY_DIR_PRESENT = "${@os.path.exists('${BSPDIR}/sources/bt-proprietary/synergy')}"
IMAGE_INSTALL += "${@bb.utils.contains('SYNERGY_DIR_PRESENT', 'True', 'alsa-lib', '', d)}"
IMAGE_INSTALL += "${@bb.utils.contains('SYNERGY_DIR_PRESENT', 'True', 'alsa-utils', '', d)}"
IMAGE_INSTALL += "rfkill"
IMAGE_INSTALL += "someip-commonsys-intf"

#Wlan driver
IMAGE_INSTALL += "wlan-cnss-core"
#IMAGE_INSTALL += "qcacld32-ll-rome"
#IMAGE_INSTALL += "qcacld32-ll-hasting"
#IMAGE_INSTALL += "${@oe.utils.version_less_or_equal('KERNELVERSION', '5.4', '', 'qcacld32-ll-hsp', d)}"
IMAGE_INSTALL += "qcacld32-ll-hamilton"
#IMAGE_INSTALL += "qcacld32-ll-rome-cnss2"
#IMAGE_INSTALL += "qcacld20-ll-rome"
#IMAGE_INSTALL += "qcacld20-hl-rome"
#IMAGE_INSTALL += "qcacld20-hl-tfl"

#Wlan tools
IMAGE_INSTALL += "wpa-supplicant"
IMAGE_INSTALL += "wpa-supplicant-8-lib"
IMAGE_INSTALL += "wlan-sigmadut"
IMAGE_INSTALL += "wlan-config"
IMAGE_INSTALL += "rng-tools"
