DESCRIPTION = "QTI Aidl Socket Library"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "qrpc-util"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/wpa_supplicant_8/wpa_supplicant/qrpc_server/aidl_sock/"
S = "${WORKDIR}/wlan-opensource/wpa_supplicant_8/wpa_supplicant/qrpc_server/aidl_sock"

do_install() {
    install -d ${D}${libdir}
    install -d ${D}${includedir}/rpc/util

    install -m 0755 ${S}/include/*.h ${D}${includedir}/rpc/util/
    install -m 0755 ${S}/libqti_aidl_sock.so.0 ${D}${libdir}

    cd ${D}${libdir}
    ln -s libqti_aidl_sock.so.0 libqti_aidl_sock.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"