SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

CLO_PATCH_URL ="https://git.codelinaro.org/clo/la/kernel/msm-3.14/-/commit/"

SRC_URI += "https://git.codelinaro.org/clo/external-wlan/patches/-/raw/caf_migration/master/Automotive/3rdparty/fsl3-10/Release_15_10_20/cfg80211_3.14.28.patch;downloadfilename=cfg80211_3.14.28.patch;md5sum=a1113fe6b4d08cc84ef852293751ea7d"

SRC_URI += "https://git.codelinaro.org/clo/la/kernel/msm-3.18/-/commit/11d200e95f3e84c1102e4cc9863a3614fd41f3ad.patch;downloadfilename=0001-Add-strchrnul.patch;md5sum=1387e55eb28cd20c21943be54b7c576a"



SRC_URI += "	${CLO_PATCH_URL}2f6ecce8947840c2233293f66b1203e9cdc06be0.patch;downloadfilename=0001-cfg80211-Add-AP-stopped-interface.patch;md5sum=801e524fbc7e9632e2eb91148ac1fdbb \
		${CLO_PATCH_URL}ea9e417116601c381ca55de987074f92c6a2efce.patch;downloadfilename=0001-cfg80211-Add-new-wiphy-flag-WIPHY_FLAG_DFS_OFFLOAD.patch;md5sum=ceb118902302092d11f0c7b2f3d9cf38 \
		${CLO_PATCH_URL}dc8a840ee81c7adefc26334f29178114fd114ca2.patch;downloadfilename=0001-cfg80211-Advertise-maximum-associated-STAs-in-AP-mod.patch;md5sum=358d926ab7b4ced6c9a2d2440c9022d5 \
		${CLO_PATCH_URL}7f09a4171fa34a0ff243876dcd9087fa7fea25ca.patch;downloadfilename=0001-mac80211-implement-HS2.0-gratuitous-ARP-unsolicited-.patch;md5sum=468fcea0ddf8c3247ff3d1877a57e880 \
		${CLO_PATCH_URL}b90fb762ba8f32b9522318cf3f56da242c7b1f91.patch;downloadfilename=0001-cfg80211-Allow-BSS-hint-to-be-provided-for-connect.patch;md5sum=a700cd4ccea6a61ae60b0ab564f74157 \
		${CLO_PATCH_URL}94eb0e21d4065c738ce8ead20da56aed04c4cabc.patch;downloadfilename=0001-cfg80211-clarify-BSS-probe-response-vs.-beacon-data.patch;md5sum=aa9e3bd6f7110220933857ec7b826257 \
		${CLO_PATCH_URL}cb52939e7e550eacb39d64391ffe344b8737d1e5.patch;downloadfilename=0001-cfg80211-Dynamic-channel-bandwidth-changes-in-AP-mod.patch;md5sum=115daa137ab065c5e2f0ce7719139626 \
		${CLO_PATCH_URL}04f1767b2df84809f64deffe4179a1188f6706be.patch;downloadfilename=0001-cfg80211-export-cfg80211_get_drvinfo-from-ethtool;md5sum=e23ba110acac5e2a97aed14d6a7c14a5 \
		${CLO_PATCH_URL}6634e158ff21260d6b24d9b4ad1aef8b9584b61d.patch;downloadfilename=0001-cfg80211-export-regulatory_hint_user-API.patch;md5sum=2c6014e3d93e2c7ed9999e3ed4100aee \
		${CLO_PATCH_URL}5099deaff00d7f4ece10a620ab98a6e989616ce3.patch;downloadfilename=0001-cfg80211-Pass-TDLS-peer-capability-information-in-td.patch;md5sum=5043b5d9b2a843d58dc1e1e572608ddd \
		${CLO_PATCH_URL}72487e61feadd6b31ebc6308d6313b219dfe1cfb.patch;downloadfilename=0001-nl80211-fix-scheduled-scan-RSSI-matchset-attribute-c.patch;md5sum=aecd69b83d5fc5d11d3945f7f51b7784 \
		"

SRC_URI += "https://git.codelinaro.org/clo/sba-patches/romeau_patches/-/raw/main/sba-patches/QCA6574AU.LE.2.2.1/cfg80211_3.14.28_wpa3.patch;downloadfilename=cfg80211_3.14.28_wpa3.patch;md5sum=9fb5a9a67abe8056036efe6ab3d30109"

SRC_URI += "https://git.codelinaro.org/clo/sba-patches/romeau_patches/-/raw/main/sba-patches/QCA6564.LE.1.0.3.c0.c1.krack/0001-WLAN-subsystem-Sysctl-support-for-key-TCP-IP-paramet-2.patch;downloadfilename=0001-WLAN-subsystem-Sysctl-support-for-key-TCP-IP-paramet-2.patch;md5sum=2b32fe56deb9084542fe5505950ccf79"

do_before_configure () {


    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_HOSTAP=y
CONFIG_CFG80211=y
CONFIG_MAC80211=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_WIRELESS_EXT=y
CONFIG_CFG80211_WEXT=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_NL80211_TESTMODE=y

CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
CONFIG_BRIDGE=y

KERNEL_EXTRACONFIGS

}

addtask before_configure after do_patch before do_configure
