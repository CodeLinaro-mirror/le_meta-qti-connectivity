DESCRIPTION = "Qualcomm Technologies, Inc. AIDL header files"
LICENSE = "BSD-3-Clause-Clear & Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a\
                    file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

PR = "r0"

FILESPATH =+ "${BSPDIR}/sources:"
SRC_URI += "file://wlan-opensource/remotewifi/interfaces/bluetooth/aidl/include"
S = "${WORKDIR}//wlan-opensource/remotewifi/interfaces/bluetooth/aidl/include"

do_install(){
    install -d ${D}${includedir}/rpc/aidl/bluetooth
    cp -rf ${S}/* ${D}${includedir}/rpc/aidl/bluetooth/
}