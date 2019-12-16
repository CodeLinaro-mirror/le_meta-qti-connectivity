SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${BSPDIR}/sources:${THISDIR}/files:"

MAINLINE_PRESENT = "${@os.path.exists('${BSPDIR}/sources/kernel')}"

python __anonymous () {

    arry=d.getVar("PV",True).split('.')

    PV_var=arry[0]+'.'+arry[1]

    if (PV_var == "4.14"):
        d.setVar("PATCH_FOLDER", "lk-4.14")
    elif (PV_var == "4.9"):
        d.setVar("PATCH_FOLDER", "lk-4.9")

    if (d.getVar("MAINLINE_PRESENT", True) == 'True'):
        d.setVar("SRC_URI", "file://kernel/ ")
        d.setVar("SRC_URI_append", "file://config/defconfig_${PV} ")
        d.setVar("S", "${WORKDIR}/kernel")

}

SRC_URI += "file://config/defconfig_${PV}"

#SRC_URI += "file://${PATCH_FOLDER}/"

do_copy_defconfig_append() {

    cat ${WORKDIR}/config/defconfig_${PV} >> ${WORKDIR}/defconfig

}

do_patch_for_kernel() {

# For RB line, need to apply kernel patch
    if [ ${MAINLINE_PRESENT} != "True" ]; then
        PATCH_PATH="${WORKDIR}/${PATCH_FOLDER}"
        cd ${S}
        for i in $(ls ${PATCH_PATH})
        do
            git am ${PATCH_PATH}/$i
        done
    fi

}

addtask do_patch_for_kernel after do_patch before do_configure
