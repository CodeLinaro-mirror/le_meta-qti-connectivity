SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://lk-4.14/0001-2748365-cfg80211-Updated-nl80211_commands-to-be-in-sync-with.patch \
            file://lk-4.14/0002-2748366-cfg80211-nl80211-Optional-authentication-offload-to-.patch \
            file://lk-4.14/0003-2748367-nl80211-Free-connkeys-on-external-authentication-fai.patch \
           "
CAF_PATCH_PATH = "https://source.codeaurora.org/quic/la/kernel/nxp/patch/?"
PATCH_NAME_4   = "0004-2748368-nl80211-Allow-SAE-Authentication-for-NL80211_CMD_CON.patch"
PATCH_NAME_5   = "0005-2748371-nl80211-Fix-external_auth-check-for-offloaded-authen.patch"
SRC_URI       += "${CAF_PATCH_PATH}id=10773a7c09b327d02144c7d181e6544b7015ffc7;downloadfilename=${PATCH_NAME_4};md5sum=9c7ff62930f4319d3dce4bc01b60e647 \
                  ${CAF_PATCH_PATH}id=db8d93a7a355121d49777c059afbca23c53c8628;downloadfilename=${PATCH_NAME_5};md5sum=0b3557374a5acf0965f0bd63ae335d0e \
                 "
SRC_URI += "file://lk-4.14/0006-2748372-cfg80211-Authentication-offload-to-user-space-in-AP-.patch \
            file://lk-4.14/0007-2762760-cfg80211-Sync-nl80211-commands-feature-with-upstream.patch \
           "
PATCH_NAME_8   = "0008-2748378-nl80211-Allow-set-del-pmksa-operations-for-AP.patch"
SRC_URI       += "${CAF_PATCH_PATH}id=6c900360e7c0df6a4846ac97d7b548d72cd801b0;downloadfilename=${PATCH_NAME_8};md5sum=bf4648f1073f2accc94f44614d87f664"
SRC_URI += "file://lk-4.14/0009-2748379-cfg80211-nl80211-Offload-OWE-processing-to-user-spac.patch"

CAF_PATCH_PATH_REG_SELF = "https://source.codeaurora.org/quic/la/kernel/msm-4.4/patch/?"
PATCH_NAME_REG_SELF = "reg-qcom-call-regulatory-callback-for-self-managed-hints.patch"
SRC_URI += "${CAF_PATCH_PATH_REG_SELF}id=31e37a680dcbb02ba41d17972dba0b298cf1983d;downloadfilename=${PATCH_NAME_REG_SELF};md5sum=c79fe89b3fbc3e9b2b578a1d1dcebf0e"

SRC_URI += "file://lk-4.14/0010-2739268-Kconfig-Add-CLD_LL_CORE-configuration-for-WLAN.patch"

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
