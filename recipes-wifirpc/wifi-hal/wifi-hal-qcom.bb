DESCRIPTION = "WiFi Hal library for qcom WLAN"
LICENSE = "Apache-2.0 & BSD-3-Clause"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10 \
    file://${COMMON_LICENSE_DIR}/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9 \
"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libnl openssl"
DEPENDS += "android-common-libs"
DEPENDS += "hardware-legacy-headers cld80211-lib"
DEPENDS += "qrpc-util"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://qwlan/qcwcn/wifi_hal/"
S = "${WORKDIR}/qwlan/qcwcn/wifi_hal"

CPPFLAGS += "-I${STAGING_INCDIR}/libnl3 -I${STAGING_INCDIR}/android"
CPPFLAGS += "-I${STAGING_INCDIR}/cld80211-lib -I${STAGING_INCDIR}/hardware_legacy"
LDFLAGS += "-L${STAGING_LIBDIR}/android"

do_compile:prepend() {
    cp ${BSPDIR}/sources/wlan-opensource/wpa_supplicant_8/src/drivers/nl80211_copy.h ${S}
}

do_install() {
    install -d ${D}${includedir}/wifi_hal_qcom/wifi_hal_ctrl
    cp ${S}/*.h ${D}${includedir}/wifi_hal_qcom
    cp ${S}/wifi_hal_ctrl/*.h ${D}${includedir}/wifi_hal_qcom/wifi_hal_ctrl

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}/${libdir}
    ln -s libwifi-hal-qcom.so.0 libwifi-hal-qcom.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
