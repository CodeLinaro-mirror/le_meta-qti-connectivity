DESCRIPTION = "WLAN Device specific config"
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=f3b90e78ea0cffb20bf5cca7947a896d"
PR = "r3"

inherit autotools systemd

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource:"

SRC_URI = "file://mdm-init/"

S = "${WORKDIR}/mdm-init/"

EXTRA_OECONF = "--enable-thirdparty-wlan=yes"

FILES:${PN} += "${datadir}/misc/wifi/*"
FILES:${PN} += "${nonarch_base_libdir}/firmware/wlan/*"
FILES:${PN} += "${sysconfdir}/init.d/*"

do_install:append() {
	BDIR="${D}${nonarch_base_libdir}/firmware/wlan"
	CFG_FILE="${BDIR}/QCA6698AU.LE.1.1_HastingPrime_PCIe_qcacld-3.0-iMX8.ini"
	ADD_FILE="${S}/wlan_standalone/wow_pcie_wake_n_imx8mqevk.ini"

	if [ "${MACHINE}" == "imx8mqevk" ]; then
		while read -r line
		do
			sed -i "/^END/i$line" ${CFG_FILE}
		done < ${ADD_FILE}
		#rm -fr ${ADD_FILE}
	fi
}
