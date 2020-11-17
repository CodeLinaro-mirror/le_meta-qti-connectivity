do_install_append(){
    install -d ${D}${base_libdir}/firmware/imx/sdma
}

PACKAGES += "${PN}-sdma"
FILES_${PN}-sdma = "${base_libdir}/firmware/imx/sdma"
