
# look for files in the layer first
DEPENDS += "libtirpc"
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://telnetd.cfg"
SRC_URI += "file://rtc_wake.cfg"
SRC_URI += "file://ftpd.cfg"
SRC_URI += "file://nfs.cfg"
SRC_URI += "file://ipconfig.cfg"

CFLAGS += "-I${STAGING_INCDIR}/tirpc"

ERROR_QA:remove = "buildpaths"
WARN_QA:append = " buildpaths"
ERROR_QA:remove = "ldflags"
WARN_QA:append = " ldflags"
