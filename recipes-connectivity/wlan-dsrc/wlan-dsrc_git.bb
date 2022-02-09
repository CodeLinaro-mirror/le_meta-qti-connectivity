DESCRIPTION = "WLAN dsrc tool for QCA devices"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"

DEPENDS = "libnl"

PR = "r0"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI = "file://wlan-opensource/dsrc-tool/ \
	  "

S = "${WORKDIR}/wlan-opensource/dsrc-tool/"

TOOL_CHAIN_PRE = ""

LIBNL3_DIR = "${STAGING_INCDIR}/libnl3"
CPPFLAGS += "-I ${LIBNL3_DIR} -I inc -I src -MMD -MP"
LDFLAGS := "-lnl-3 -lnl-genl-3"

do_compile() {
	cd ${S}/dsrc/
	make CROSS_COMPILE=${TOOL_CHAIN_PRE}
	make CROSS_COMPILE=${TOOL_CHAIN_PRE} dsrc_config
	make CROSS_COMPILE=${TOOL_CHAIN_PRE} wlan_ts
}

do_install() {
	install -d ${D}/${bindir}
	install -m 0755 ${S}/dsrc/${TOOL_CHAIN_PRE}bin/dsrc_* ${D}/${bindir}/
	install -m 0755 ${S}/dsrc/${TOOL_CHAIN_PRE}bin/wlan_ts ${D}/${bindir}/
	install -m 0755 ${S}/dsrc/${TOOL_CHAIN_PRE}bin/dcc.dat ${D}/${bindir}/
}

FILES_${PN} += "${bindir}*"
FILES_${PN}-dbg += "${bindir}/.debug/*"

