DESCRIPTION = "WiFi hal common library"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

inherit clang
TOOLCHAIN = "clang"
DEPENDS = "clang-cross-${TARGET_ARCH}"
DEPENDS += "libnl android-common-libs"
DEPENDS += "hardware-legacy-headers cld80211-lib wifi-hal-qcom"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://wifi/"
S = "${WORKDIR}/wifi"

TARGET_LIBS = "libwifi-system-iface libwifi-system libwifi-hal"

CPPFLAGS += "-I${STAGING_INCDIR}/libnl3 -I${STAGING_INCDIR}/android"
CPPFLAGS += "-I${STAGING_INCDIR}/hardware_legacy -I${STAGING_INCDIR}/cld80211-lib"
LDFLAGS += "-L${STAGING_LIBDIR}/android"

do_compile() {
    make -C ${S}/libwifi_system_iface
    make -C ${S}/libwifi_system
    make -C ${S}/libwifi_hal
}

do_install() {
    install -d ${D}${includedir}
    cp -rf ${S}/libwifi_system_iface/include/* ${D}${includedir}/
    cp -rf ${S}/libwifi_system/include/* ${D}${includedir}/
    cp -rf ${S}/libwifi_hal/include/* ${D}${includedir}/

    install -d ${D}${libdir}
    install -m 0755 ${S}/libwifi_system_iface/*.so.0 ${D}/${libdir}
    install -m 0755 ${S}/libwifi_system/*.so.0 ${D}/${libdir}
    install -m 0755 ${S}/libwifi_hal/*.so.0 ${D}/${libdir}
    cd ${D}/${libdir}
    for lib in ${TARGET_LIBS}; do
        ln -s ${lib}.so.0 ${lib}.so
    done
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"
