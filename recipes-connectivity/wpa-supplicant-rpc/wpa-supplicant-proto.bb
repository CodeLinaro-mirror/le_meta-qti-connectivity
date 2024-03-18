DESCRIPTION = "QTI Wpa-supplicant Proto Library"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "protobuf-native protobuf qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/remotewifi/interfaces/wifi/supplicant/aidl/android/hardware/wifi/supplicant"
S = "${WORKDIR}"

AIDL_PATH = "/wlan-opensource/remotewifi/interfaces/wifi/supplicant/aidl/android/hardware/wifi/supplicant"

do_compile:prepend() {
    mkdir -p ${S}/a2p_gen
    a2p --aidl-path ${S}${AIDL_PATH} --proto-path ${S}/a2p_gen --makefile-type makefile
    mkdir -p ${S}/a2p_gen/gen
    protoc -I${S}/a2p_gen --cpp_out=${S}/a2p_gen/gen ${S}/a2p_gen/*.proto
    cd ${S}/a2p_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/proto/wpa_supplicant
    install -m 0755 ${S}/a2p_gen/gen/*.pb.h ${D}${includedir}/rpc/proto/wpa_supplicant
    install -m 0755 ${S}/a2p_gen/*.proto ${D}${includedir}/rpc/proto/wpa_supplicant

    install -d ${D}${libdir}
    install -m 0755 ${S}/a2p_gen/*.so.0 ${D}/${libdir}

    cd ${D}${libdir}
    ln -s libqti-wifi-supplicant-proto.so.0 libqti-wifi-supplicant-proto.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"
