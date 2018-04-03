
FILESEXTRAPATHS_append := ":${THISDIR}/systemd-230"

SRC_URI_append += "file://70-net-setup-link.rules \
		  "

do_install_append() {
  install -m 0644 ${WORKDIR}/70-net-setup-link.rules ${D}${sysconfdir}/udev/rules.d/

}
