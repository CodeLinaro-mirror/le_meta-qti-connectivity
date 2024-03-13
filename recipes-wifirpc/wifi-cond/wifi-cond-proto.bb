DESCRIPTION = "QTI Wifi Cond Proto Library"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "protobuf-native protobuf qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = " \
    file://wlan-opensource/remotewifi/interfaces/wifi/netlinkinterceptor/aidl/android/hardware/net/nlinterceptor \
"
S = "${WORKDIR}"

AIDL_PATH = "${S}/wlan-opensource/remotewifi/interfaces/wifi/netlinkinterceptor/aidl/android/hardware/net/nlinterceptor"

do_compile:prepend() {
    mkdir -p ${S}/a2p_gen/gen
    a2p --aidl-path ${AIDL_PATH} --proto-path ${S}/a2p_gen --makefile-type makefile
    protoc -I${S}/a2p_gen --cpp_out=${S}/a2p_gen/gen ${S}/a2p_gen/*.proto
    cd ${S}/a2p_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/proto/wificond
    install -m 0755 ${S}/a2p_gen/gen/*.pb.h ${D}${includedir}/rpc/proto/wificond
    install -m 0755 ${S}/a2p_gen/*.proto ${D}${includedir}/rpc/proto/wificond

    install -d ${D}${libdir}
    install -m 0755 ${S}/a2p_gen/*.so.0 ${D}/${libdir}
    cd ${D}${libdir}
    ln -s libqti-net-nlinterceptor-proto.so.0 libqti-net-nlinterceptor-proto.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
