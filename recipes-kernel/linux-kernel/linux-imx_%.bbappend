SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${BSPDIR}/sources:${THISDIR}/files:"

MAINLINE_PRESENT = "${@os.path.exists('${BSPDIR}/sources/kernel')}"

python __anonymous () {

    arry=d.getVar("PV",True).split('.')

    PV_var=arry[0]+'.'+arry[1]

    d.setVar("SRC_URI", "file://kernel/ ")
    d.setVar("SRC_URI_append", "file://config/defconfig_${PV} ")
    d.setVar("S", "${WORKDIR}/kernel")

}

SRC_URI += "file://config/defconfig_${PV}"



do_copy_defconfig_append() {

    cat ${WORKDIR}/config/defconfig_${PV} >> ${WORKDIR}/defconfig

}


