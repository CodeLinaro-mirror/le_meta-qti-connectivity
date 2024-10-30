DESCRIPTION = "Wi-Fi Protected Access(WPA) Supplicant"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

inherit autotools linux-kernel-base pkgconfig systemd
DEPENDS = "openssl libnl virtual/kernel android-common-libs vsomeip"
DEPENDS += "wpa-supplicant-8-lib"
DEPENDS += "qrpc-util"
DEPENDS += "wpa-supplicant-message wpa-supplicant-vendor-message hostapd-message hostapd-vendor-message"

FILESPATH =+ "${BSPDIR}/sources:"

FILES:${PN} += "${sbindir}/*"
FILES:${PN} += "${libdir}/lib*.so"
FILES:${PN}-dbg += "${sbindir}/.debug"

SRC_URI = "file://wlan-opensource/wpa_supplicant_8/"
SRC_URI += "file://hostapdconf \
            file://supplicantconf \
           "

S = "${WORKDIR}/wlan-opensource/wpa_supplicant_8"
SUPPLICANT_CONFIG_PATH = "/data/vendor/wifi/wpa"
HOSTAPD_CONFIG_PATH = "/data/vendor/wifi/hostapd"

do_configure() {
	install -m 0644 ${WORKDIR}/hostapdconf ${S}/hostapd/.config
	install -m 0644 ${WORKDIR}/supplicantconf ${S}/wpa_supplicant/.config
	sed  -i -e 's/\-I\/usr\/include\/libnl3//g' ${S}/src/drivers/drivers.mk
	sed  -i -e 's/\-I\/usr\/include\/libnl3//g' ${S}/src/drivers/drivers.mak
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> ${S}/hostapd/.config
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> ${S}/wpa_supplicant/.config
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/android\"" >> ${S}/hostapd/.config
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/android\"" >> ${S}/wpa_supplicant/.config
	echo "LDFLAGS +=\"-L${STAGING_LIBDIR}/android\"" >> ${S}/hostapd/.config
	echo "LDFLAGS +=\"-L${STAGING_LIBDIR}/android\"" >> ${S}/wpa_supplicant/.config
}

do_compile() {
	cd ${S}
	oe_runmake -C wpa_supplicant clean
	oe_runmake -C wpa_supplicant
	oe_runmake -C hostapd clean
	oe_runmake -C hostapd
}

do_install() {
	install -d ${D}${sbindir}
	install -m 0755 ${S}/wpa_supplicant/wpa_supplicant ${D}${sbindir}
	install -m 0755 ${S}/wpa_supplicant/wpa_cli ${D}${sbindir}
	install -m 0755 ${S}/hostapd/hostapd ${D}${sbindir}
	install -m 0755 ${S}/hostapd/hostapd_cli ${D}${sbindir}
	install -d ${D}${bindir}
	install -m 0755 ${S}/wpa_supplicant/wpa_passphrase ${D}${bindir}

	install -d ${D}${SUPPLICANT_CONFIG_PATH}
	install -m 0755 ${S}/wpa_supplicant/wpa_supplicant_template.conf ${D}/${SUPPLICANT_CONFIG_PATH}/wpa_supplicant.conf
	install -d ${D}${HOSTAPD_CONFIG_PATH}
	install -m 0755 ${S}/hostapd/hostapd.conf ${D}/${HOSTAPD_CONFIG_PATH}/hostapd.conf

	if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        	install -m 0644 -p -D ${S}/hostapd/script/hostapd.service ${D}${systemd_unitdir}/system/hostapd.service
		install -m 0644 -p -D ${S}/wpa_supplicant/script/wpa_supplicant.service ${D}${systemd_unitdir}/system/wpa_supplicant.service
	fi
}

FILES:${PN} += "${SUPPLICANT_CONFIG_PATH}/* ${HOSTAPD_CONFIG_PATH}/* ${systemd_unitdir}/system/*"
SYSTEMD_SERVICE:${PN} += "wpa_supplicant.service hostapd.service"