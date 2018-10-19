
FILESEXTRAPATHS_append := ":${THISDIR}/files"
SRC_URI += "file://0001-Add-cnss2-support-for-two-PCIe-wlan-card.patch"

do_configure_prepend () {
cat >> ${S}/arch/${ARCH}/configs/${KERNEL_CONFIG} <<KERNEL_EXTRACONFIGS
CONFIG_CNSS2=y
CONFIG_CNSS2_DEBUG=y
CONFIG_CNSS_LOGGER=y
# CONFIG_CNSS is not set
# CONFIG_CNSS_ASYNC is not set
KERNEL_EXTRACONFIGS
}
