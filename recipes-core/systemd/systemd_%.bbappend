
FILESEXTRAPATHS_append := ":${THISDIR}/systemd-230"

SRC_URI_append += "file://systemd-net-buffer-tune.sh"

do_install_append() {
  # add a profile fragment to tune the network buffer size
	install -Dm 0644 ${WORKDIR}/systemd-net-buffer-tune.sh  \
	 ${D}${sysconfdir}/profile.d/systemd-net-buffer-tune.sh

}

FILES_${PN} += "${sysconfdir}/profile.d/systemd-net-buffer-tune.sh"
