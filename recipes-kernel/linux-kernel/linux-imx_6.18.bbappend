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

SRC_URI += "file://config/connectivity_6.18.cfg"

SRC_URI += " \
	file://${PATCH_FOLDER}/0001-update-dts-to-support-Hamilton-Chip.patch \
	file://${PATCH_FOLDER}/0003-cfg80211-Add-MLO-backport-flag.patch \
	file://${PATCH_FOLDER}/0005-kernel-fix-the-issue-ttyLP1-is-missed-if-QC-BT-is-us.patch \
	file://${PATCH_FOLDER}/0010-imx8mq.dtsi-Add-wlan-mhi-resource.patch \
	file://${PATCH_FOLDER}/0011-msi-revert-code-genirq-msi-cache-the-latest-msi-msg.patch \
	file://${PATCH_FOLDER}/0013-Bluetooth-hci_qca-Support-QCA-Auto-chips.patch \
"


