# Signature for modules when kernel request signing key.
# Before inheriting this class, make sure all parameters are defined int bb file.

do_sign () {
    KMOD_SIG_ALL=`cat ${STAGING_KERNEL_BUILDDIR}/.config | grep CONFIG_MODULE_SIG_ALL | cut -d'=' -f2`
    KMOD_SIG_HASH=`cat ${STAGING_KERNEL_BUILDDIR}/.config | grep CONFIG_MODULE_SIG_HASH | cut -d'=' -f2 | sed 's/\"//g'`
    if [ "$KMOD_SIG_ALL" = "y" ] && [ -n "$KMOD_SIG_HASH" ]; then
        if [ "${KERNEL_VERSION:0:3}" = "4.4" ]; then
            MODSECKEY=${STAGING_KERNEL_BUILDDIR}/certs/signing_key.pem
            MODPUBKEY=${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509
        else
            MODSECKEY=${STAGING_KERNEL_BUILDDIR}/signing_key.priv
            MODPUBKEY=${STAGING_KERNEL_BUILDDIR}/signing_key.x509
        fi

        cp ${S}/${WLAN_MODULE_NAME}.ko ${S}/${WLAN_MODULE_NAME}.ko-unsigned

        if [ "${KERNEL_VERSION:0:3}" = "4.4" ]; then
            ${STAGING_KERNEL_BUILDDIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/${WLAN_MODULE_NAME}.ko
        else
            perl ${STAGING_KERNEL_DIR}/scripts/sign-file $KMOD_SIG_HASH $MODSECKEY $MODPUBKEY ${S}/${WLAN_MODULE_NAME}.ko
        fi
    fi;
}

addtask do_sign after do_package before do_package_write_ipk
