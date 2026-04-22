SCMVERSION = "n"

FILESEXTRAPATHS:prepend := "${BSPDIR}/sources:${THISDIR}/files:"

MAINLINE_PRESENT = "${@os.path.exists('${BSPDIR}/sources/kernel')}"

python __anonymous () {
    d.setVar("PATCH_FOLDER", "lk-${KERNELVERSION}")
    d.setVar("ADDON_FOLDER", "lk-addon-${KERNELVERSION}")

    if (d.getVar("MAINLINE_PRESENT", True) == 'True'):
        d.setVar("SRC_URI", "file://kernel/ ")
        d.appendVar("SRC_URI", " file://config/defconfig_${KERNELVERSION}")
        d.setVar("S", "${WORKDIR}/kernel")
}

SRC_URI += "file://config/defconfig_${KERNELVERSION}"

SRC_URI += " \
	file://${PATCH_FOLDER}/0001-dts-configure-for-genoa-wlan-card.patch \
	file://${PATCH_FOLDER}/0003-cfg80211-Add-MLO-backport-flag.patch \
	file://${PATCH_FOLDER}/0005-kernel-fix-the-issue-ttyLP1-is-missed-if-QC-BT-is-us.patch \
	file://${PATCH_FOLDER}/0010-imx8mq.dtsi-Add-wlan-mhi-resource.patch \
	file://${PATCH_FOLDER}/0011-msi-revert-code-genirq-msi-cache-the-latest-msi-msg.patch \
	file://${PATCH_FOLDER}/0012-kernel-export-symbol-irq_to_desc.patch \
	file://${PATCH_FOLDER}/0013-Bluetooth-hci_qca-Support-QCA-Auto-chips.patch \
"

do_copy_defconfig:append() {
    cat ${UNPACKDIR}/config/defconfig_${KERNELVERSION} >> ${B}/.config
}
