FILESEXTRAPATHS:prepend := "${THISDIR}/dnsmasq:"
SRC_URI += "file://dnsmasq_current.conf"

do_install:append () {
        install -Dm 0644 ${WORKDIR}/dnsmasq_current.conf ${D}${sysconfdir}/dnsmasq.conf
}