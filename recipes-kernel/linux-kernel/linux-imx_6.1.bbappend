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
"


do_copy_defconfig:append() {
    cat ${WORKDIR}/config/defconfig_${KERNELVERSION} >> ${B}/.config
}
