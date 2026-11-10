DESCRIPTION = "Qualcomm Technologies, Inc. CNSS platform driver (wlan-cnss-core) for Congo"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit module kernel-arch

PACKAGE_ARCH = "${MACHINE_ARCH}"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:iq-9075-evk = "(.*)"

FILESEXTRAPATHS:prepend = "${LAYERDIR_qcom_connectivity}/../wlan-opensource:"
SRC_URI = "file://wlan-cnss-core/"

S = "${UNPACKDIR}/wlan-cnss-core"

DEPENDS = "virtual/kernel"

FILES:${PN} += "${modprobedir}/blacklist-ath11k.conf"

do_compile:prepend() {
    cp ${S}/include/linux/mhi.h ${STAGING_KERNEL_DIR}/include/linux/mhi.h
    cp ${S}/include/linux/ipc_logging.h ${STAGING_KERNEL_DIR}/include/linux/ipc_logging.h

    sed -i '/Werror/d' ${S}/Kbuild
}

do_install() {
    module_do_install

    install -d ${DEPLOY_DIR_IMAGE}/wlan
    install -m 0644 ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/updates/*.ko ${DEPLOY_DIR_IMAGE}/wlan/

    install -d ${D}${includedir}/wlan-cnss-core
    install -m 0644 ${S}/inc/*.h ${D}${includedir}/wlan-cnss-core/

    install -d ${D}${modprobedir}
    echo "blacklist ath11k" > ${D}${modprobedir}/blacklist-ath11k.conf
    echo "blacklist ath11k_pci" >> ${D}${modprobedir}/blacklist-ath11k.conf
}
