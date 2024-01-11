DESCRIPTION = "Qualcomm wpa_supplicant_8_lib library."
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PR = "r0"

inherit autotools pkgconfig

DEPENDS = "libnl"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/remotewifi/qwlan/qcwcn/wpa_supplicant_8_lib/"
S = "${WORKDIR}/wlan-opensource/remotewifi/qwlan/qcwcn/wpa_supplicant_8_lib"

export WPA_SUPPLICANT_DIR = "${BSPDIR}/sources/wlan-opensource/wpa_supplicant_8"

EXTRA_OECONF = "--enable-debug=yes"

FILES:${PN} += "${libdir}/*.so.* ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"