DESCRIPTION = "Qualcomm Technologies, Inc. WLAN CLD low latency driver version 3.0 for Hasting Prime"

inherit qcacld-30-common

WLAN_MODULE_NAME = "wlan-hsp"

PACKAGES =+ "kernel-module-${WLAN_MODULE_NAME}"

DEPENDS += "wlan-cnss-core"

EXTRA_OEMAKE += "CONFIG_QCA_CLD_WLAN_PROFILE=qca6490 CHIP_NAME=qca6490 MODNAME=${WLAN_MODULE_NAME}"
EXTRA_OEMAKE += "CONFIG_CNSS2=y CONFIG_CNSS_QCA6490=y CONFIG_HIF_PCI=y"
EXTRA_OEMAKE += "CONFIG_WLAN_DISABLE_EXPORT_SYMBOL=y CONFIG_SLUB_DEBUG_ON=n CONFIG_SLUB_DEBUG=n"
EXTRA_OEMAKE += "CONFIG_FEATURE_COEX=y CONFIG_QCACLD_FEATURE_BTC_CHAIN_MODE=y"

do_compile_prepend() {
     # Using default qcacld-3.0 absolute path, get compilation error:
     # make[3]: execvp: /bin/sh: Argument list too long.
     # Becasue the Makefile argument including the objects files
     # paths is too long to complete the compilation.
     # Create soft link to the directory above KERNEL_SRC to fix this issue.
     # Need override the parameter M to use qcacld-3.0 relative path.
     # Need use wlan-cnss-core extra symbols when generating module.
     ln -nsf ${WORKDIR}/qcacld-3.0 ${STAGING_KERNEL_DIR}/../qcacld-3.0
     ln -nsf ${WORKDIR}/qca-wifi-host-cmn ${STAGING_KERNEL_DIR}/../qca-wifi-host-cmn
     ln -nsf ${WORKDIR}/fw-api ${STAGING_KERNEL_DIR}/../fw-api
     export M=../qcacld-3.0
     export KBUILD_EXTRA="KBUILD_EXTRA_SYMBOLS=${STAGING_INCDIR}/wlan-cnss-core/Module.symvers"
}

do_install_prepend() {
    export M=../qcacld-3.0
}
