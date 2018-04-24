SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-2221407-cfg80211-Use-new-wiphy-flag-WIPHY_FLAG_DFS_OFFLOAD.patch  \
            file://0002-2221408-mac80211-implement-HS2.0-gratuitous-ARP-unsolicited-.patch  \
            file://0003-2221409-cfg80211-export-regulatory_hint_user-API.patch \
            file://0004-2224213-net-cnss-Add-snapshot-of-cnss-driver.patch \
            file://0005-2227362-make-CNSS-work-up-for-SDIO-device-on-kernel-4.9.patch \
            file://0006-2227831-Enable-CNSS-PCI-platform-module.patch \
            file://0007-2232783-Remove-PCI-host-controller-driver-dependency.patch  \
            file://0008-2247541-Enable-UART5-for-BT.patch \
            file://0009-2259006-Update-db.txt.patch \
            file://0010-2264510-cfg80211-fix-build-error-about-cfg80211_roam_info.patch  \
            file://0011-2268473-Fix-the-error-return-dismatch-with-qcacld2.0-wlan-dr.patch  \
           "

do_copy_defconfig_append () {
    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_PCI=y
CONFIG_PCI_IMX6=y
CONFIG_BCMDHD=n
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CNSS=n
CONFIG_CNSS_SDIO=n
CONFIG_CNSS_LOGGER=y
CONFIG_WCNSS_MEM_PRE_ALLOC=n
CONFIG_CNSS_CRYPTO=n
CONFIG_CNSS_PCI=n
CONFIG_CLD_LL_CORE=y
KERNEL_EXTRACONFIGS
}
