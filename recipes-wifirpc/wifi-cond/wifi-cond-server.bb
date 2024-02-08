DESCRIPTION = "QTI WiFiCond Service based on SomeIP Server"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libnl android-common-libs"
DEPENDS += "qrpc-util wifi-cond-message wifi-cond-nlmsg-message"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://wificond"
S = "${WORKDIR}/wificond"

CPPFLAGS += "-I${STAGING_INCDIR}/libnl3 -I${STAGING_INCDIR}/android" 
CPPFLAGS += "-I${STAGING_INCDIR}/rpc -I${STAGING_INCDIR}/rpc/proto/wificond/ -I${STAGING_INCDIR}/rpc/message/wificond/"
LDFLAGS += "-L${STAGING_LIBDIR}/android -L${STAGING_LIBDIR}"

do_install() {
    install -d ${D}/${bindir}
    install -m 0755 ${S}/wificond-someip-service ${D}/${bindir}/
}

FILES:${PN} += "${bindir}*"
