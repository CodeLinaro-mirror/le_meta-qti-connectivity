DESCRIPTION = "Hardware legacy library and eported header files"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI = "file://libhardware_legacy/"
S = "${WORKDIR}/libhardware_legacy"

do_install() {
    install -d ${D}${includedir}
    cp -rf ${S}/include/* ${D}${includedir}/

    install -d ${D}${libdir}
    install -m 0755 ${S}/*.so.0 ${D}/${libdir}
    cd ${D}/${libdir}
    ln -s libhardware-legacy-headers.so.0 libhardware-legacy-headers.so
}

FILES:${PN} += "${libdir}/*.so.0 ${includedir}*"
FILES:${PN}-dev += "${libdir}/*.so"

