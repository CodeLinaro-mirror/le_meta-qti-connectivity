DESCRIPTION = "QTI Hardware WiFi Hal Service based on SomeIP Server"
LICENSE = "Apache-2.0 & BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10 \
    file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a \
"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libnl android-common-libs"
DEPENDS += "hardware-legacy-headers cld80211-lib wifi-hal-qcom wifi-hal-lib wifi-ndk-header"
DEPENDS += "qrpc-util wifi-server"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://interfaces/wifi/aidl/default/"
S = "${WORKDIR}/interfaces/wifi/aidl/default"

CPPFLAGS += "-I${STAGING_INCDIR}/libnl3 -I${STAGING_INCDIR}/android"
CPPFLAGS += "-I${STAGING_INCDIR}/hardware_legacy -I${STAGING_INCDIR}/cld80211-lib"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/util -I${STAGING_INCDIR}/rpc/aidl/wifi -I${STAGING_INCDIR}/rpc/server/wifi"
LDFLAGS += "-L${STAGING_LIBDIR}/android -L${STAGING_LIBDIR}"

do_install() {
    install -d ${D}/${bindir}
    install -m 0755 ${S}/wifihal-someip-service ${D}/${bindir}/
}

FILES:${PN} += "${bindir}*"
