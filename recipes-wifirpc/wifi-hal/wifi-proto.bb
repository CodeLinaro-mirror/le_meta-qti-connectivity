DESCRIPTION = "QTI Wifi Hal Proto Library"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "protobuf-native protobuf qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/remotewifi/interfaces/wifi/aidl/android/hardware/wifi/"
S = "${WORKDIR}"

AIDL_PATH = "${S}/wlan-opensource/remotewifi/interfaces/wifi/aidl/android/hardware/wifi"

do_compile() {
    mkdir -p ${S}/a2p_gen
    a2p --aidl-path ${AIDL_PATH} --proto-path ${S}/a2p_gen --makefile-type makefile
    mkdir -p ${S}/a2p_gen/gen
    protoc -I${S}/a2p_gen --cpp_out=${S}/a2p_gen/gen ${S}/a2p_gen/*.proto
    make -C ${S}/a2p_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/proto/wifi
    install -m 0755 ${S}/a2p_gen/gen/*.pb.h ${D}${includedir}/rpc/proto/wifi
    install -m 0755 ${S}/a2p_gen/*.proto ${D}${includedir}/rpc/proto/wifi

    install -d ${D}${libdir}
    install -m 0755 ${S}/a2p_gen/*.so.0 ${D}/${libdir}

    cd ${D}${libdir}
    ln -s libqti-wifi-proto.so.0 libqti-wifi-proto.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
