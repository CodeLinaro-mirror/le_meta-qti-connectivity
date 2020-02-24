#Standalone Automotive image BBFILE
#The project specific tasks needs to be added in specific
#project related include file, ${PROJECTID}-image.inc file.

IMAGE_INSTALL = "packagegroup-core-boot ${CORE_IMAGE_EXTRA_INSTALL}"

IMAGE_LINGUAS = " "

inherit core-image

IMAGE_ROOTFS_SIZE ?= "139264"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

require ${PROJECTID}-image.inc

#Common Required Tasks Listed
IMAGE_INSTALL += "iw"
IMAGE_INSTALL += "iperf3"
IMAGE_INSTALL += "wpa-supplicant"
IMAGE_INSTALL += "wlan-sigmadut"
IMAGE_INSTALL += "wlan-config"
IMAGE_INSTALL += "rng-tools"

SYNERGY_DIR_PRESENT = "${@os.path.exists('${BSPDIR}/sources/synergy-bt-proprietary')}"
IMAGE_INSTALL += "${@bb.utils.contains('SYNERGY_DIR_PRESENT', 'True', 'alsa-lib', '', d)}"
IMAGE_INSTALL += "${@bb.utils.contains('SYNERGY_DIR_PRESENT', 'True', 'alsa-utils', '', d)}"
