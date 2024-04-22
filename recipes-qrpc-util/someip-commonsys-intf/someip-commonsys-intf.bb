SUMMARY = "Qualcomm Technologies, Inc. SOME/IP Configuration file"
DESCRIPTION = "SOME/IP json configuration files"
LICENSE = "BSD-3-Clause & BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/BSD-3-Clause;md5=550794465ba0ec5312d6919e203a55f9\
                                         file://${COREBASE}/meta/files/common-licenses/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

PROVIDES = "someip-commonsys-intf"
SRCREV = "${AUTOREV}"
FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://vendor/qcom/opensource/commonsys-intf/someip"
S = "${WORKDIR}//vendor/qcom/opensource/commonsys-intf/someip"

SOMEIP_CONFIG_PATH = "/vendor/etc/someip"
inherit pkgconfig

do_install(){
    install -d ${D}/${SOMEIP_CONFIG_PATH}
    install -m 0755 ${S}/config/*.json  ${D}/${SOMEIP_CONFIG_PATH}/
}

FILES:${PN} +=  "${SOMEIP_CONFIG_PATH} ${SOMEIP_CONFIG_PATH}/*"

