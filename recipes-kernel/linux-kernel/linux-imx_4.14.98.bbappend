SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


#SRC_URI += "file://lk-4.14/0001-cfg80211-Updated-nl80211_commands-to-be-in-sync-with.patch \
#            file://lk-4.14/0002-cfg80211-nl80211-Optional-authentication-offload-to-.patch \
#	    file://lk-4.14/0003-nl80211-Free-connkeys-on-external-authentication-fai.patch \
#	    file://lk-4.14/0004-nl80211-Allow-SAE-Authentication-for-NL80211_CMD_CON.patch \	    
# 	    file://lk-4.14/0005-nl80211-Fix-external_auth-check-for-offloaded-authen.patch \	    
#	    file://lk-4.14/0006-cfg80211-Authentication-offload-to-user-space-in-AP-.patch \	    
#	    file://lk-4.14/0007-cfg80211-Sync-nl80211-commands-feature-with-upstream.patch \	    
#	    file://lk-4.14/0008-nl80211-Allow-set-del-pmksa-operations-for-AP.patch \	    
#	    file://lk-4.14/0009-cfg80211-nl80211-Offload-OWE-processing-to-user-spac.patch \	    
#	    file://lk-4.14/0010-reg-qcom-call-regulatory-callback-for-self-managed-h.patch \	    
# 	    file://lk-4.14/0011-cfg80211-Add-flags-to-support-WPA3-STA-AP-function.patch \	    
# 	    file://lk-4.14/0012-imx-kernel.lnx.4.14.98-change-file-to-support-buildi.patch \	    
#            "

   

do_compile_prepend() {
	cp -rf ${BSPDIR}/sources/kernel/* ${STAGING_KERNEL_DIR}
}





do_copy_defconfig_append () {


cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_BCMDHD=n
CONFIG_BCMDHD_1363=n
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_CLD_LL_CORE=n
CONFIG_ATH10K=n
CONFIG_ATH10K_PCI=n
CONFIG_ARCH_ALPINE=n
CONFIG_ARCH_HISI=n
CONFIG_ARCH_MVEBU=n
CONFIG_ARCH_QCOM=n
CONFIG_ARM_SMMU=y
CONFIG_STACKTRACE=y
CONFIG_BRIDGE=y
CONFIG_TMPFS=y
CONFIG_CNSS_LOGGER=n
CONFIG_CRC_CCITT=y
KERNEL_EXTRACONFIGS
               
}
