DESCRIPTION = "QTI WiFi RPC Server Library"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "wifi-ndk-header qrpc-util wifi-message"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://interfaces/wifi/rpc/server/"
S = "${WORKDIR}/interfaces/wifi/rpc/server"

EXTRA_OEMAKE += "CONFIG_DEBUG=y“

CPPFLAGS += "-I${STAGING_INCDIR}/android"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/util"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/aidl/wifi"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/proto/wifi"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/message/wifi"
LDFLAGS += "-L${STAGING_LIBDIR}/android -L${STAGING_LIBDIR}"

do_install() {
    install -d ${D}${includedir}/rpc/server/wifi
    install -m 0755 ${S}/include/*.h ${D}${includedir}/rpc/server/wifi/

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}${libdir}
    ln -s libqti-wifi-server.so.0 libqti-wifi-server.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
