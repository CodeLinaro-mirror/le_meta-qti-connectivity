DESCRIPTION = "Wi-Fi Protected Access(WPA) Supplicant"
LICENSE = "BSD"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/\
${LICENSE};md5=3775480a712fc46a69647678acb234cb"

inherit autotools linux-kernel-base
DEPENDS = "openssl libnl virtual/kernel"

FILESPATH =+ "${BSPDIR}/sources:"

FILES_${PN} += "${sbindir}/*"
FILES_${PN} += "${libdir}/lib*.so"
FILES_${PN}-dbg += "${sbindir}/.debug"

PV = "2.5-dev"
PR = "r0"

SRC_URI = "file://wlan-opensource/wpa_supplicant_8/"
SRC_URI += "file://hostapdconf \
            file://supplicantconf \
           "

S = "${WORKDIR}/wlan-opensource/wpa_supplicant_8"

do_configure() {
	install -m 0644 ${WORKDIR}/hostapdconf ${S}/hostapd/.config
	install -m 0644 ${WORKDIR}/supplicantconf ${S}/wpa_supplicant/.config
	sed  -i -e 's/\-I\/usr\/include\/libnl3//g' ${S}/src/drivers/drivers.mk
	sed  -i -e 's/\-I\/usr\/include\/libnl3//g' ${S}/src/drivers/drivers.mak
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> ${S}/hostapd/.config
	echo "CFLAGS +=\"-I${STAGING_INCDIR}/libnl3\"" >> ${S}/wpa_supplicant/.config
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
}
