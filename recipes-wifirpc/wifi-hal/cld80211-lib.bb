DESCRIPTION = "Qualcomm cld80211 library."
LICENSE = " BSD-3-Clause & BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit autotools pkgconfig

DEPENDS = "libnl"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://qwlan/cld80211-lib/"
S = "${WORKDIR}/qwlan/cld80211-lib"

EXTRA_OECONF = "--enable-debug=yes"

FILES:${PN} += "${libdir}/*.so.* ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
