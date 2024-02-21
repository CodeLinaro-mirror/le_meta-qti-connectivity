DESCRIPTION = "QTI Hardware WiFi Hal NDK Headers library"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "android-common-libs"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://interfaces/wifi/aidl/ndk_header/"
S = "${WORKDIR}/interfaces/wifi/aidl/ndk_header"

CPPFLAGS += "-I${STAGING_INCDIR}/android"
LDFLAGS += "-L${STAGING_LIBDIR}/android"

do_install() {
    install -d ${D}${includedir}/rpc/aidl/wifi
    install -m 0755 ${S}/*.h ${D}${includedir}/rpc/aidl/wifi/
    cp -rf ${S}/include/* ${D}${includedir}/rpc/aidl/wifi/

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}${libdir}
    ln -s libwifi-ndk-header.so.0 libwifi-ndk-header.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
