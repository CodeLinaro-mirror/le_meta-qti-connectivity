FILESEXTRAPATHS:prepend := "${THISDIR}/dnsmasq:"

SRC_URI += " \
    file://0001-dnsmasq-Enable-auto-SAP-dhcp-configuration.patch \
"
