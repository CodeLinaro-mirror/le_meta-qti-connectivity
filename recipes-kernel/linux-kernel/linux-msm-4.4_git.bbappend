FILESEXTRAPATHS_append := ":${THISDIR}/files"

KERNEL_SRC = "git://source.codeaurora.org/quic/la/kernel/msm-4.4"
SRC_BRANCH = "LV.HB.1.1.1_rb1.46"
SRC_TAG    = "LV.HB.1.1.1-36610-8x96.0"
SRC_URI    = "${KERNEL_SRC};protocol=http;branch=${SRC_BRANCH};tag=${SRC_TAG}"
SRC_URI   += "file://0001-Add-cnss2-support-for-two-PCIe-wlan-card.patch"

S = "${WORKDIR}/git"

do_configure_prepend () {
cat >> ${S}/arch/${ARCH}/configs/${KERNEL_CONFIG} <<KERNEL_EXTRACONFIGS
CONFIG_CNSS2=y
CONFIG_CNSS2_DEBUG=y
CONFIG_CNSS_LOGGER=y
# CONFIG_CNSS is not set
# CONFIG_CNSS_ASYNC is not set
KERNEL_EXTRACONFIGS
}
