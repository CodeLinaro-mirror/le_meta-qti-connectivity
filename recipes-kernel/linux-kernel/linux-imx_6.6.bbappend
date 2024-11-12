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

SRC_URI += "${@bb.utils.contains('FEATURE_CNSS_STANDALONE', '1', 'file://config/defconfig_${KERNELVERSION}_cnss_standalone', 'file://config/defconfig_${KERNELVERSION}', d)}"


SRC_URI += " \
	file://${PATCH_FOLDER}/0001-update-dts-to-support-Hamilton-Chip.patch \
	file://${PATCH_FOLDER}/0002-update-dts-to-add-32k-sleep-clock-at-imx8qxpmek.patch \
	file://${PATCH_FOLDER}/0003-cfg80211-Add-MLO-backport-flag.patch \
	file://${PATCH_FOLDER}/0004-kernel-export-symbol-stack_trace_save_tsk.patch \
	file://${PATCH_FOLDER}/0005-kernel-fix-the-issue-ttyLP1-is-missed-if-QC-BT-is-us.patch \
        file://${PATCH_FOLDER}/0006-Add-configuration-support-for-BT-I2S-slave-master.patch \
        file://${PATCH_FOLDER}/0008-Use-IMX8QXP-M.2-pin23-GPIO-for-BT_EN-Control.patch \
        file://${PATCH_FOLDER}/0009-Add-btpower-driver-for-QCA-chip-BT-power-ctrl.patch \
        file://${PATCH_FOLDER}/0010-Control-WLAN-EP-power-in-RC-driver.patch \
"

SRC_URI += "${@bb.utils.contains('FEATURE_CNSS_STANDALONE', '1', 'file://${PATCH_FOLDER}/0007-update-kernel-for-build-standalone-cnss-driver.patch', '', d)}"

do_copy_defconfig:append() {
    cat ${WORKDIR}/config/defconfig_${KERNELVERSION} >> ${B}/.config
}
