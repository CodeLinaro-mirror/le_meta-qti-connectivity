DESCRIPTION = "QTI WiFiCond Service based on SomeIP Server"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

inherit clang systemd
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libnl android-common-libs"
DEPENDS += "qrpc-util wifi-cond-message wifi-cond-nlmsg-message"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://wificond"
S = "${WORKDIR}/wificond"
COND_RPC_RXMSG_PATH = "/vendor/wifi/rxmsg/"
COND_RPC_TXMSG_PATH = "/vendor/wifi/txmsg/"

CPPFLAGS += "-I${STAGING_INCDIR}/libnl3 -I${STAGING_INCDIR}/android" 
CPPFLAGS += "-I${STAGING_INCDIR}/rpc -I${STAGING_INCDIR}/rpc/proto/wificond/ -I${STAGING_INCDIR}/rpc/message/wificond/"
LDFLAGS += "-L${STAGING_LIBDIR}/android -L${STAGING_LIBDIR}"

do_install() {
    install -d ${D}/${COND_RPC_RXMSG_PATH}
    install -d ${D}/${COND_RPC_TXMSG_PATH}
    install -d ${D}/${bindir}
    install -d ${D}/${systemd_unitdir}
    install -d ${D}/${systemd_unitdir}/system
    install -d ${D}/${systemd_unitdir}/system/multi-user.target.wants
    install -m 0755 ${S}/wificond-someip-service ${D}/${bindir}/
    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -m 0644 -p -D ${S}/script/wificond-someip-service.service ${D}${systemd_unitdir}/system/wificond-someip-service.service
        ln -sf ${systemd_unitdir}/system/wificond-someip-service.service ${D}${systemd_unitdir}/system/multi-user.target.wants/wificond-someip-service.service
    fi
}

FILES:${PN} += "${bindir}* ${systemd_unitdir}/system/*"
FILES:${PN} += " ${COND_RPC_RXMSG_PATH}"
FILES:${PN} += " ${COND_RPC_TXMSG_PATH}"
