SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

#SRC_URI = "file://kernel/ \
#          "
CAF_PATCH_PATH = "https://source.codeaurora.org/quic/la/kernel/msm-3.18/patch/?"
PATCH_NAME_1 = "0001-Add-strchrnul.patch"

SRC_URI += "${CAF_PATCH_PATH}id=11d200e95f3e84c1102e4cc9863a3614fd41f3ad;downloadfilename=${PATCH_NAME_1};md5sum=21ef285e9df777511552fa1079d369e0"

do_patch_prepend() {
    bb.build.exec_func('do_download_patches', d)
}

do_download_patches() {
    cd ${WORKDIR}
    wget https://www.codeaurora.org/patches/external/wlan/Automotive/3rdparty/fsl3-10/Release_15_05_25/cfg80211_3.10.17.patch
    wget https://source.codeaurora.org/quic/romeau/sba-patches/plain/sba-patches/QCA6584AU.LE.2.0.1-ES.tar.gz
    tar -xzvf QCA6584AU.LE.2.0.1-ES.tar.gz
    rm QCA6584AU.LE.2.0.1-ES.tar.gz
}

python do_patch_append() {
    import subprocess
    bb.build.exec_func('do_patch_for_wlan', d)
}

do_patch_for_wlan() {
    process_tmpdir=`mktemp -d patchtempXXXX000`
    TMPDIR=${process_tmpdir}

    patch -p1 < ../cfg80211_3.10.17.patch
        # neglect a patch conflict on wiphy_flags
    ! patch -p1 < ../QCA6584AU.LE.2.0.1-ES/3.10.17/backport-to-3.10-nl80211-cfg80211-add-5-10MHz-defines.patch
    patch -p1 < ../QCA6584AU.LE.2.0.1-ES/3.10.17/0001-WLAN-subsystem-Sysctl-support-for-key-TCP-IP-paramet.patch
    patch -p1 < ../QCA6584AU.LE.2.0.1-ES/3.10.17/cfg80211_wiphy_flags.patch
    patch -p1 < ../QCA6584AU.LE.2.0.1-ES/3.10.17/backport-to-3.10-sort-and-extend-wireless-element-id-list.patch

    rm -rf ${process_tmpdir}
}

do_before_configure () {


    cat >> ${WORKDIR}/defconfig <<KERNEL_EXTRACONFIGS
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_NL80211_TESTMODE=y

CONFIG_CFG80211_REG_DEBUG=y
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_DEBUGFS=y
CONFIG_CFG80211_INTERNAL_REGDB=y
KERNEL_EXTRACONFIGS

}

addtask before_configure after do_patch before do_configure
