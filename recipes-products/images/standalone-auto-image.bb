#Standalone Automotive image BBFILE
#The project specific tasks needs to be added in specific
#project related include file, ${PROJECTID}-image.inc file.

IMAGE_INSTALL = "packagegroup-core-boot ${ROOTFS_PKGMANAGE_BOOTSTRAP} ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

inherit core-image

IMAGE_ROOTFS_SIZE ?= "131072"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

require ${PROJECTID}-image.inc

#Common Required Tasks Listed
IMAGE_INSTALL += "iw"
IMAGE_INSTALL += "wireless-tools"
IMAGE_INSTALL += "iperf"
IMAGE_INSTALL += "wpa-supplicant-2.5-dev"
IMAGE_INSTALL += "wlan-sigmadut"
IMAGE_INSTALL += "wlan-config"

SYNERGY_DIR_PRESENT = "${@os.path.exists('${BSPDIR}/sources/synergy-bt-proprietary')}"
IMAGE_INSTALL += "${@base_conditional('SYNERGY_DIR_PRESENT', 'True', 'alsa-lib', '', d)}"
IMAGE_INSTALL += "${@base_conditional('SYNERGY_DIR_PRESENT', 'True', 'alsa-utils', '', d)}"
