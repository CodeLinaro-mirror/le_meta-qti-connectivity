FILESEXTRAPATHS:prepend := "${THISDIR}/dhcpcd:"

SRC_URI += " \
    file://0001-dhcpcd-Disable-auto-IP-configuration.patch \
"
