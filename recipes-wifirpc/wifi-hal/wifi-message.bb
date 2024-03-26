DESCRIPTION = "QTI Wifi Aidl Proto Message Library"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "wifi-ndk-header wifi-proto qrpc-util qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/remotewifi/interfaces/wifi/aidl/android/hardware/wifi/"
S = "${WORKDIR}"

AIDL_PATH = "${S}/wlan-opensource/remotewifi/interfaces/wifi/aidl/android/hardware/wifi"

CPPFLAGS += "-I${STAGING_INCDIR}/rpc/aidl/wifi"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/proto/wifi"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/util"
LDFLAGS += "-L${STAGING_LIBDIR}"

do_compile() {
    mkdir -p ${S}/apcc_gen
    apcc.py --aidl_path ${AIDL_PATH} --proto_path ${STAGING_INCDIR}/rpc/proto/wifi --out_path ${S}/apcc_gen --base_intf IWifi -impl -id -makefile
    make -C ${S}/apcc_gen CONFIG_WIFI=y CONFIG_WIFI_AP_IFACE=y CONFIG_WIFI_CHIP=y CONFIG_WIFI_STA_IFACE=y
}

do_install() {
    install -d ${D}${includedir}/rpc/message/wifi
    install -m 0755 ${S}/apcc_gen/include/*.h ${D}${includedir}/rpc/message/wifi
    install -m 0755 ${S}/apcc_gen/message/include/*.h ${D}${includedir}/rpc/message/wifi

    install -d ${D}${libdir}
    install -m 0755 ${S}/apcc_gen/*.so.0 ${D}/${libdir}

    cd ${D}${libdir}
    ln -s libqti-wifi-message.so.0 libqti-wifi-message.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
