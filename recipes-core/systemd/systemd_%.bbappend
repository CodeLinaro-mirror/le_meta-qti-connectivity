
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://systemd-net-buffer-tune.sh \
                   file://ram-dump-umh.sh \
                  "

do_install:append() {
  # add a profile fragment to tune the network buffer size
	install -Dm 0644 ${UNPACKDIR}/systemd-net-buffer-tune.sh  \
	 ${D}${sysconfdir}/profile.d/systemd-net-buffer-tune.sh
	install -Dm 0755 ${UNPACKDIR}/ram-dump-umh.sh \
	 ${D}${sbindir}/ram-dump-umh.sh
}

FILES:${PN} += "${sysconfdir}/profile.d/systemd-net-buffer-tune.sh"
FILES:${PN} += "${sbindir}/ram-dump-umh.sh"