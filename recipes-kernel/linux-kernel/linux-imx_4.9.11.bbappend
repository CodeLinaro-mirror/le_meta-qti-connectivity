SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${BSPDIR}/sources:"

SRC_URI = "file://kernel/ \
          "

S = "${WORKDIR}/kernel"

do_copy_defconfig_append () {
    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_PCI=y
CONFIG_BCMDHD=n
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CLD_LL_CORE=y
KERNEL_EXTRACONFIGS
}
