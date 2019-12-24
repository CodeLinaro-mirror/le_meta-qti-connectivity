SCMVERSION = "n"

FILESEXTRAPATHS_prepend := "${BSPDIR}/sources:${THISDIR}/files:"

MAINLINE_PRESENT = "${@os.path.exists('${BSPDIR}/sources/kernel')}"

python __anonymous () {

    arry=d.getVar("PV",True).split('.')

    PV_var=arry[0]+'.'+arry[1]

    if (PV_var == "4.14"):
        d.setVar("PATCH_FOLDER", "lk-4.14")
    elif (PV_var == "4.9"):
        d.setVar("PATCH_FOLDER", "lk-4.9")

    if (d.getVar("MAINLINE_PRESENT", True) == 'True'):
        d.setVar("SRC_URI", "file://kernel/ ")
        d.setVar("SRC_URI_append", "file://config/defconfig_${PV} ")
        d.setVar("S", "${WORKDIR}/kernel")

}

SRC_URI += "file://config/defconfig_${PV}"

SRC_URI += "file://${PATCH_FOLDER}/"

SRC_URI += " \
https://source.codeaurora.org/quic/la/kernel/nxp/patch/?id=10773a7c09b327d02144c7d181e6544b7015ffc7;downloadfilename=0004-2748368-nl80211-Allow-SAE-Authentication-for-NL80211_CMD_CON.patch;md5sum=9c7ff62930f4319d3dce4bc01b60e647;apply=no;subdir=${PATCH_FOLDER} \
https://source.codeaurora.org/quic/la/kernel/nxp/patch/?id=db8d93a7a355121d49777c059afbca23c53c8628;downloadfilename=0005-2748371-nl80211-Fix-external_auth-check-for-offloaded-authen.patch;md5sum=0b3557374a5acf0965f0bd63ae335d0e;apply=no;subdir=${PATCH_FOLDER} \
https://source.codeaurora.org/quic/la/kernel/nxp/patch/?id=6c900360e7c0df6a4846ac97d7b548d72cd801b0;downloadfilename=0008-2748378-nl80211-Allow-set-del-pmksa-operations-for-AP.patch;md5sum=bf4648f1073f2accc94f44614d87f664;apply=no;subdir=${PATCH_FOLDER} \
https://source.codeaurora.org/quic/la/kernel/msm-4.4/patch/?id=31e37a680dcbb02ba41d17972dba0b298cf1983d;downloadfilename=0012-reg-qcom-call-regulatory-callback-for-self-managed-hints.patch;md5sum=c79fe89b3fbc3e9b2b578a1d1dcebf0e;apply=no;subdir=${PATCH_FOLDER} \
https://source.codeaurora.org/quic/la/kernel/msm-4.4/patch/?id=b05f752db8d2e6d3edf2e6ea6799e7f6e6c8d3be;downloadfilename=0013-cfg80211-Add-backport-flag-for-user-cellular-base-hint.patch;md5sum=c8c234f77ca9ebe2ec67f91db2f1895a;apply=no;subdir=${PATCH_FOLDER} \
https://source.codeaurora.org/quic/la/kernel/msm-4.4/patch/?id=df55603b24bc48fd765332d71a9ca1f82c1e8e39;downloadfilename=0014-nl80211-fix-nlmsg-allocation-in-cfg80211_ft_event.patch;md5sum=9ff5b62db8f26b564bf77c26124a1058;apply=no;subdir=${PATCH_FOLDER} \
	"

do_copy_defconfig_append() {

    cat ${WORKDIR}/config/defconfig_${PV} >> ${WORKDIR}/defconfig

}

do_patch_for_kernel() {

# For RB line, need to apply kernel patch
    if [ ${MAINLINE_PRESENT} != "True" ]; then
        PATCH_PATH="${WORKDIR}/${PATCH_FOLDER}"
        cd ${S}
        for i in $(ls ${PATCH_PATH})
        do
            patch -p1 -d . < ${PATCH_PATH}/$i
        done
    fi

}

addtask do_patch_for_kernel after do_patch before do_configure
