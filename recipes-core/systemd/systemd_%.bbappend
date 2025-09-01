
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://systemd-net-buffer-tune.sh"

do_install:append() {
  # add a profile fragment to tune the network buffer size
	install -Dm 0644 ${UNPACKDIR}/systemd-net-buffer-tune.sh  \
	 ${D}${sysconfdir}/profile.d/systemd-net-buffer-tune.sh

}

FILES_${PN} += "${sysconfdir}/profile.d/systemd-net-buffer-tune.sh"
