DESCRIPTION = "QTI WiFi Cond Aidl Proto Message Library"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "wifi-cond-nlmsg-proto qrpc-util"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://wificond/nlmsg_message"
S = "${WORKDIR}/wificond/nlmsg_message"

CPPFLAGS += "-I${STAGING_INCDIR}/rpc/proto/wificond -I${STAGING_INCDIR}/rpc/util"
LDFLAGS += "-L${STAGING_LIBDIR}"
EXTRA_OEMAKE += "CONFIG_INTERCEPTOR=y"

do_install() {
    install -d ${D}${includedir}/rpc/message/wificond
    cp ${S}/include/*.h ${D}${includedir}/rpc/message/wificond/

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}${libdir}
    ln -s libqti_wifi_nlmsgInfo_message.so.0 libqti_wifi_nlmsgInfo_message.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
