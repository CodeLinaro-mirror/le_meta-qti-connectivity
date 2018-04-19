
FILESEXTRAPATHS_append := ":${THISDIR}/systemd-230"

SRC_URI_append += "file://70-net-setup-link.rules \
                   file://blacklist-wlan-tfl.conf \
		  "

do_install_append() {
  install -d ${D}${sysconfdir}/modprobe.d

  install -m 0644 ${WORKDIR}/70-net-setup-link.rules ${D}${sysconfdir}/udev/rules.d/
  install -m 0644 ${WORKDIR}/blacklist-wlan-tfl.conf ${D}${sysconfdir}/modprobe.d/

}

FILES_${PN} += "${sysconfdir}/modprobe.d/*"
