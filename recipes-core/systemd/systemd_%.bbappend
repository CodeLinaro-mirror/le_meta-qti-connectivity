
FILESEXTRAPATHS:append := ":${THISDIR}/systemd-230"

SRC_URI:append += "file://systemd-net-buffer-tune.sh \
                   file://01-fwdump-udev.rules \
                   file://fw-ram-dump.sh \
                  "

do_install:append() {
  # add a profile fragment to tune the network buffer size
	install -Dm 0644 ${WORKDIR}/systemd-net-buffer-tune.sh  \
	 ${D}${sysconfdir}/profile.d/systemd-net-buffer-tune.sh
	install -Dm 0644 ${WORKDIR}/01-fwdump-udev.rules \
	 ${D}${sysconfdir}/udev/rules.d/01-fwdump-udev.rules
	install -Dm 0755 ${WORKDIR}/fw-ram-dump.sh \
	 ${D}${sbindir}/fw-ram-dump.sh

}

FILES_${PN} += "${sysconfdir}/profile.d/systemd-net-buffer-tune.sh"
FILES_${PN} += "${sysconfdir}/udev/rules.d/01-fwdump-udev.rules"
FILES_${PN} += "${sbindir}/fw-ram-dump.sh"