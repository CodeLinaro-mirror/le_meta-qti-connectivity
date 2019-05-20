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
            file://0012-2284816-cnss-add-pointer-null-check-before-use.patch \
            file://0013-2338459-cfg80211-Amendment-for-Use-new-wiphy-flag-WIPHY_FLAG.patch \
            file://0014-2351541-cfg80211-Bypass-checkin-the-CHAN_RADAR-if-DFS_OFFLOA.patch \
            file://0015-2407178-cfg80211-Fix-use-after-free-when-process-wdev-events.patch \
            file://0016-2406371-CNSS-update-code-to-fix-blacklist-CR-and-compile-err.patch \
            file://0017-2505736-CNSS-cnss-logger-can-be-built-even-no-CNSS-module.patch \
            file://0018-2685513-cfg80211-NL80211_ATTR_SOCKET_OWNER-support-for-CMD_C.patch \
            file://0019-2685514-cfg80211-Updated-nl80211_commands-to-be-in-sync-with.patch \
            file://0020-2685515-cfg80211-nl80211-Optional-authentication-offload-to-.patch \
            file://0021-2685516-nl80211-Free-connkeys-on-external-authentication-fai.patch \
            file://0022-2685517-nl80211-Allow-SAE-Authentication-for-NL80211_CMD_CON.patch \
            file://0023-2685518-cfg80211-indicate-support-for-external-authenticatio.patch \
            file://0024-2685519-nl80211-Fix-external_auth-check-for-offloaded-authen.patch \
            file://0025-2711454-cfg80211-configure-multicast-to-unicast-for-AP-inter.patch \
            file://0026-2711472-cfg80211-Add-support-to-update-connection-parameters.patch \
            file://0027-2717214-nl80211-synchronize-kernel-two-variables-value-in-en.patch \
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
CONFIG_BRIDGE=y
KERNEL_EXTRACONFIGS
}
