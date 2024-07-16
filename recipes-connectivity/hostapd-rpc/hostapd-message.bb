DESCRIPTION = "QTI hostapd Aidl Proto Message Library"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "hostapd-aidl hostapd-proto qrpc-util qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/remotewifi/interfaces/wifi/hostapd/aidl/android/hardware/wifi/hostapd"
S = "${WORKDIR}"

AIDL_PATH = "/wlan-opensource/remotewifi/interfaces/wifi/hostapd/aidl/android/hardware/wifi/hostapd"

EXTRA_OEMAKE += "CONFIG_HOSTAPD=y"

CPPFLAGS += "-I${STAGING_INCDIR}/rpc/aidl/hostapd -I${STAGING_INCDIR}/rpc/proto/hostapd -I${STAGING_INCDIR}/rpc/util"
LDFLAGS += "-L${STAGING_LIBDIR}"

do_compile:prepend() { 
    mkdir -p ${S}/apcc_gen
    apcc.py --aidl_path ${S}${AIDL_PATH} --proto_path ${STAGING_INCDIR}/rpc/proto/hostapd --out_path ${S}/apcc_gen --base_intf IHostapd -impl -id -makefile
    cd ${S}/apcc_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/message/hostapd
    install -m 0755 ${S}/apcc_gen/include/*.h ${D}${includedir}/rpc/message/hostapd
    install -m 0755 ${S}/apcc_gen/message/include/*.h ${D}${includedir}/rpc/message/hostapd

    install -d ${D}${libdir}
    install -m 0755 ${S}/apcc_gen/*.so.0 ${D}/${libdir}  

    cd ${D}${libdir}
    ln -s libqti-wifi-hostapd-message.so.0 libqti-wifi-hostapd-message.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
