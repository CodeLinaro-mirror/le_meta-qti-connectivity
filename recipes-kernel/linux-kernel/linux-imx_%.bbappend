SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://lk-4.14/0001-2748365-cfg80211-Updated-nl80211_commands-to-be-in-sync-with.patch \
            file://lk-4.14/0002-2748366-cfg80211-nl80211-Optional-authentication-offload-to-.patch \
            file://lk-4.14/0003-2748367-nl80211-Free-connkeys-on-external-authentication-fai.patch \
            file://lk-4.14/0004-2748368-nl80211-Allow-SAE-Authentication-for-NL80211_CMD_CON.patch \
            file://lk-4.14/0005-2748371-nl80211-Fix-external_auth-check-for-offloaded-authen.patch \
            file://lk-4.14/0006-2748372-cfg80211-Authentication-offload-to-user-space-in-AP-.patch \
            file://lk-4.14/0007-2762760-cfg80211-Sync-nl80211-commands-feature-with-upstream.patch \
            file://lk-4.14/0008-2748378-nl80211-Allow-set-del-pmksa-operations-for-AP.patch \
            file://lk-4.14/0009-2748379-cfg80211-nl80211-Offload-OWE-processing-to-user-spac.patch \
            file://lk-4.14/0010-2739268-Kconfig-Add-CLD_LL_CORE-configuration-for-WLAN.patch \
            file://lk-4.14/0011-2776447-cnss-Add-support-of-cnss-logger-module.patch \
            file://lk-4.14/reg-qcom-call-regulatory-callback-for-self-managed-hints.patch \
           "

do_copy_defconfig_append () {

case ${PV} in

   "4.14.78")
               {
    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_BCMDHD=n
CONFIG_BCMDHD_1363=n
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CLD_LL_CORE=y
CONFIG_ATH10K=n
CONFIG_ATH10K_PCI=n
CONFIG_ARCH_ALPINE=n
CONFIG_ARCH_HISI=n
CONFIG_ARCH_MVEBU=n
CONFIG_ARCH_QCOM=n
CONFIG_ARM_SMMU=n
CONFIG_STACKTRACE=y
CONFIG_BRIDGE=y
CONFIG_TMPFS=y
CONFIG_CNSS_LOGGER=n
CONFIG_PCI=y
CONFIG_PCI_IMX6=y
CONFIG_PCI_MSI=y
KERNEL_EXTRACONFIGS
               };;

   "4.9.11")
               {
    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_PCI=y
CONFIG_PCI_IMX6=y
CONFIG_BCMDHD=n
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CNSS=n
CONFIG_CNSS_SDIO=n
CONFIG_CNSS_LOGGER=n
CONFIG_WCNSS_MEM_PRE_ALLOC=n
CONFIG_CNSS_CRYPTO=n
CONFIG_CNSS_PCI=n
CONFIG_CLD_LL_CORE=y
CONFIG_BRIDGE=y
KERNEL_EXTRACONFIGS
               };;
esac
}
