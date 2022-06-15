SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${BSPDIR}/sources:${THISDIR}/files:"

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
SRC_URI += "file://${PATCH_FOLDER}/"
SRC_URI += "file://${ADDON_FOLDER}/"

do_copy_defconfig_append() {
    cat ${WORKDIR}/config/defconfig_${KERNELVERSION} >> ${B}/.config
}

add_on_patch() {
    ADDON_PATH="${WORKDIR}/${ADDON_FOLDER}"
    if [ ! -d ${ADDON_PATH} ]; then
        return
    fi

    if [ ${FEATURE_RCPM} == "1" ]; then
        patch -N --silent -p1 -d ${S} < ${ADDON_PATH}/"rcpm_msi.patch"
    fi
}

do_patch_for_kernel() {
    # For RB line, need to apply kernel patch
    PATCH_PATH="${WORKDIR}/${PATCH_FOLDER}"
    if [ "${MAINLINE_PRESENT}" != "True" ]; then
        for i in $(ls ${PATCH_PATH})
        do
            patch -N --silent -p1 -d ${S} < ${PATCH_PATH}/$i
        done
	add_on_patch
    fi
}

addtask do_patch_for_kernel after do_patch before do_configure
