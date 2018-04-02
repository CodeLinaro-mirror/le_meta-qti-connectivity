DESCRIPTION = "WFA certification testing tool for QCA devices"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

PR = "r0"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/sigma-dut/ \
	  "

S = "${WORKDIR}/wlan-opensource/sigma-dut/"

do_install() {
	install -d ${D}/${bindir}
	install -m 0755 ${S}/sigma_dut ${D}/${bindir}
}

FILES_${PN} += "${bindir}*"
FILES_${PN}-dbg += "${bindir}/.debug/*"
