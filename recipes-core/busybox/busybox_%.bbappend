
# look for files in the layer first
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://telnetd.cfg"
SRC_URI += "file://rtc_wake.cfg"
SRC_URI += "file://ftpd.cfg"

