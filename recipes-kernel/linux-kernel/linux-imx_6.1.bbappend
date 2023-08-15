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
	file://${PATCH_FOLDER}/0001-dts-add-cnss2-converged-devices-support.patch \
	file://${PATCH_FOLDER}/0002-update-im8mq-evk-device-tree-to-enable-m2BT.patch \
	file://${PATCH_FOLDER}/0003-Add-wlan-en-gpio-resource.patch \
	file://${PATCH_FOLDER}/0004-Add-MSM-bt-power-module.patch \
	file://${PATCH_FOLDER}/0005-Enable-configure-for-rx-fcs-error-report.patch \
	file://${PATCH_FOLDER}/0006-Add-32k-support-for-imx8qxp.patch \
"

do_copy_defconfig:append() {
    cat ${WORKDIR}/config/defconfig_${KERNELVERSION} >> ${B}/.config
}
