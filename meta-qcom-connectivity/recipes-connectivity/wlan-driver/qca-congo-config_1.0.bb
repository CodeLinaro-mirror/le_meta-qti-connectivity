DESCRIPTION = "Congo (fig_v2) INI — WCNSS_qcom_cfg.ini shipped in-recipe under files/."
LICENSE = "ISC"
LIC_FILES_CHKSUM = "file://WCNSS_qcom_cfg.ini;beginline=1;endline=2;md5=e97692d5e662d2c34f564e41fe850e23"

SRC_URI = " \
    file://WCNSS_qcom_cfg.ini \
    file://10-congo-wlan.link \
"

S = "${UNPACKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/wlan/qca_cld/fig_v2
    install -m 0644 ${S}/WCNSS_qcom_cfg.ini \
        ${D}${nonarch_base_libdir}/firmware/wlan/qca_cld/fig_v2/WCNSS_qcom_cfg.ini
    install -d ${D}${nonarch_libdir}/systemd/network
    install -m 0644 ${S}/10-congo-wlan.link ${D}${nonarch_libdir}/systemd/network/10-congo-wlan.link
}

FILES:${PN} = " \
    ${nonarch_base_libdir}/firmware/wlan/qca_cld/fig_v2/WCNSS_qcom_cfg.ini \
    ${nonarch_libdir}/systemd/network/10-congo-wlan.link \
"

INSANE_SKIP:${PN} += "already-stripped ldflags arch buildpaths file-rdeps libdir staticdev"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

COMPATIBLE_MACHINE = "^$"
COMPATIBLE_MACHINE:iq-9075-evk = "(.*)"
