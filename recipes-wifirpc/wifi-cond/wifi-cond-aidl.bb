DESCRIPTION = "Qualcomm Technologies, Inc. AIDL header files"
LICENSE = "Apache-2.0 & BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

PR = "r0"

FILESPATH =+ "${BSPDIR}/sources/wlan-opensource/remotewifi:"
SRC_URI += "file://wificond/aidl/include"
S = "${WORKDIR}//wificond/aidl/include"

do_install(){
    install -d ${D}${includedir}/rpc/aidl/wificond
    cp -rf ${S}/* ${D}${includedir}/rpc/aidl/wificond/
}