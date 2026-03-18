SUMMARY = "Tools for the Linux Standard Wireless Extension Subsystem"
HOMEPAGE = "https://hewlettpackard.github.io/wireless-tools/Tools.html"
LICENSE = "GPL-2.0-only & (LGPL-2.1-only | MPL-1.1 | BSD-1-Clause)"
LIC_FILES_CHKSUM = "file://COPYING;md5=94d55d512a9ba36caa9b7df079bae19f \
			file://iwconfig.c;beginline=1;endline=12;md5=cf710eb1795c376eb10ea4ff04649caf \
			file://iwevent.c;beginline=59;endline=72;md5=d66a10026d4394f0a5b1c5587bce4537 \
			file://sample_enc.c;beginline=1;endline=4;md5=838372be07874260b566bae2f6ed33b6"
SECTION = "base"
PE = "1"

SRC_URI = "https://hewlettpackard.github.io/wireless-tools/wireless_tools.${PV}.tar.gz;md5sum=ca91ba7c7eff9bfff6926b1a34a4697d;sha256sum=abd9c5c98abf1fdd11892ac2f8a56737544fe101e1be27c6241a564948f34c63 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/rocko/meta/recipes-connectivity/wireless-tools/wireless-tools/remove.ldconfig.call.patch;md5sum=20a2b6450076da2207ab128b2f52295e;sha256sum=00e8fa61e84813bf22eb85ecc50d5a5d5048e405bdd28600986b04088f6087e3 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/rocko/meta/recipes-connectivity/wireless-tools/wireless-tools/man.patch;md5sum=7baff4ff73c9b1608561a4d0cb52800d;sha256sum=26f6ec100566a1ff46accc70dc3473dbf316706554c12fdc2447651456110ed0 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/rocko/meta/recipes-connectivity/wireless-tools/wireless-tools/avoid_strip.patch;md5sum=55d2267271332d52e3915658f3fe687d;sha256sum=bf8edf61ee556807e2333c74071e00a145743e26d089e25d0276e04e4341c2a6 \
           https://git.codelinaro.org/clo/ype/external/yoctoproject.org/poky/-/raw/yocto/rocko/meta/recipes-connectivity/wireless-tools/wireless-tools/ldflags.patch;md5sum=fdb3d712d97d38963e3d50598c97a6b9;sha256sum=ccd8dafb90dc6bd3f32e9523a40683f622411fe5d396070938d2c8d998eb257c \
"
SRC_URI[sha256sum] = "abd9c5c98abf1fdd11892ac2f8a56737544fe101e1be27c6241a564948f34c63"

UPSTREAM_CHECK_URI = "https://hewlettpackard.github.io/wireless-tools/Tools.html"
UPSTREAM_CHECK_REGEX = "wireless_tools\.(?P<pver>(\d+)(\..*|))\.tar\.gz"

S = "${UNPACKDIR}/wireless_tools.30"

CFLAGS =+ "-I${S}"
EXTRA_OEMAKE = "-e 'BUILD_SHARED=y' \
		'INSTALL_DIR=${D}${base_sbindir}' \
		'INSTALL_LIB=${D}${libdir}' \
		'INSTALL_INC=${D}${includedir}' \
		'INSTALL_MAN=${D}${mandir}'"

do_compile() {
	oe_runmake all libiw.a
}

do_install() {
	oe_runmake PREFIX=${D} install-iwmulticall install-dynamic install-man install-hdr
	install -d ${D}${sbindir}
	install -m 0755 ifrename ${D}${sbindir}/ifrename
}

PACKAGES = "libiw libiw-dev libiw-doc ifrename-doc ifrename ${PN} ${PN}-doc ${PN}-dbg"

FILES:libiw = "${libdir}/*.so.*"
FILES:libiw-dev = "${libdir}/*.a ${libdir}/*.so ${includedir}"
FILES:libiw-doc = "${mandir}/man7"
FILES:ifrename = "${sbindir}/ifrename"
FILES:ifrename-doc = "${mandir}/man8/ifrename.8 ${mandir}/man5/iftab.5"
FILES:${PN} = "${bindir} ${sbindir}/iw* ${base_sbindir} ${base_bindir} ${sysconfdir}/network"
FILES:${PN}-doc = "${mandir}"
