SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI +="file://0001-2397783-net-cnss-Add-snapshot-of-cnss-driver.patch \
           file://0002-2397791-make-CNSS-work-up-for-SDIO-device-on-kernel-4.1.15.patch \
           file://0003-2397793-Enable-CNSS-PCI-platform-module.patch \
           file://0004-2397796-Enable-UART5-for-BT.patch \
           file://0005-2397798-Update-db.txt.patch \
           file://0006-2397802-kernel-change-for-wlan-driver-on-BSP-4.1.15.patch \
           file://0007-2506983-CNSS-cnss-logger-can-be-built-even-no-CNSS-module.patch \
           file://0008-2506999-cnss-add-pointer-null-check-before-use.patch \
           file://0009-2507004-cfg80211-Fix-use-after-free-when-process-wdev-events.patch \
           file://0010-2507007-CNSS-update-code-to-fix-blacklist-CR-and-compile-err.patch \
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
CONFIG_FHANDLE=y
CONFIG_IKCONFIG=y
KERNEL_EXTRACONFIGS
}


