DESCRIPTION = "QTI Wpa-supplicant Vendor Aidl Proto Message Library"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "wpa-supplicant-aidl wpa-supplicant-vendor-proto qrpc-util qrpc-tool-native"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://vendor/qcom/opensource/interfaces/wifi/supplicant/aidl/vendor/qti/hardware/wifi/supplicant"
S = "${WORKDIR}"

AIDL_PATH_VENDOR = "/vendor/qcom/opensource/interfaces/wifi/supplicant/aidl/vendor/qti/hardware/wifi/supplicant"

EXTRA_OEMAKE += "CONFIG_SUPPLICANT_VENDOR=y CONFIG_SUPPLICANT_VENDOR_STA_IFACE=y"

CPPFLAGS += "-I${STAGING_INCDIR}/rpc/aidl/wpa_supplicant -I${STAGING_INCDIR}/rpc/proto/wpa_supplicant_vendor -I${STAGING_INCDIR}/rpc/util"
LDFLAGS += "-L${STAGING_LIBDIR}"

do_compile:prepend() {
    mkdir -p ${S}/apcc_gen
    apcc.py --aidl_path ${S}${AIDL_PATH_VENDOR} --proto_path ${STAGING_INCDIR}/rpc/proto/wpa_supplicant_vendor --out_path ${S}/apcc_gen --base_intf ISupplicantVendor --msg_def_offset 0x1000 -impl -id -makefile
    cd ${S}/apcc_gen
}

do_install() {
    install -d ${D}${includedir}/rpc/message/wpa_supplicant_vendor
    install -m 0755 ${S}/apcc_gen/include/*.h ${D}${includedir}/rpc/message/wpa_supplicant_vendor
    install -m 0755 ${S}/apcc_gen/message/include/*.h ${D}${includedir}/rpc/message/wpa_supplicant_vendor

    install -d ${D}${libdir}
    install -m 0755 ${S}/apcc_gen/*.so.0 ${D}/${libdir}

    cd ${D}${libdir}
    ln -s libqti-supplicant-vendor-message.so.0 libqti-supplicant-vendor-message.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}/*"
FILES:${PN}-dev += "${libdir}/*.so"