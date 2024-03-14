DESCRIPTION = "QTI WiFi Cond Proto Library"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "protobuf-native protobuf"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://wificond/nlmsg_proto/"
S = "${WORKDIR}/wificond/nlmsg_proto"

do_compile:prepend() {
    mkdir -p ${S}/gen
    protoc -I${S} --cpp_out=${S}/gen *.proto
}

do_install() {
    install -d ${D}${includedir}/rpc/proto/wificond
    cp -rf ${S}/gen/*.pb.h ${D}${includedir}/rpc/proto/wificond

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}${libdir}
    ln -s libqti-wifi-nlmsgInfo-proto.so.0 libqti-wifi-nlmsgInfo-proto.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
