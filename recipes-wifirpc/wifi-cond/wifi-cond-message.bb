DESCRIPTION = "QTI Wifi Cond Aidl Proto Message Library"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "wifi-cond-proto wifi-cond-aidl qrpc-util qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = " \
    file://wlan-opensource/remotewifi/interfaces/wifi/netlinkinterceptor/aidl/android/hardware/net/nlinterceptor/ \
"
S = "${WORKDIR}"

EXTRA_OEMAKE += "CONFIG_INTERCEPTOR=y"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/aidl/wificond"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/proto/wificond"
CPPFLAGS += "-I${STAGING_INCDIR}/rpc/util"
LDFLAGS += "-L${STAGING_LIBDIR}"
AIDL_PATH = "${S}/wlan-opensource/remotewifi/interfaces/wifi/netlinkinterceptor/aidl/android/hardware/net/nlinterceptor"

do_compile:prepend() {
    mkdir -p ${S}/apcc_gen
    apcc.py --aidl_path ${AIDL_PATH} --proto_path ${STAGING_INCDIR}/rpc/proto/wificond --out_path ${S}/apcc_gen --base_intf IInterceptor -impl -id -makefile
    cd ${S}/apcc_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/message/wificond
    install -m 0755 ${S}/apcc_gen/include/*.h ${D}${includedir}/rpc/message/wificond
    install -m 0755 ${S}/apcc_gen/message/include/*.h ${D}${includedir}/rpc/message/wificond

    install -d ${D}${libdir}
    install -m 0755 ${S}/apcc_gen/*.so.0 ${D}/${libdir}

    cd ${D}${libdir}
    ln -s libqti-net-nlinterceptor-message.so.0 libqti-net-nlinterceptor-message.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
