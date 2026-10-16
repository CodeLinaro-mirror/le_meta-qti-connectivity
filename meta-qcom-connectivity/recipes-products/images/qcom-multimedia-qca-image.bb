require recipes-products/images/qcom-multimedia-image.bb

SUMMARY = "Multimedia image with the downstream Congo (qcacld) WLAN driver instead of ath11k"

CORE_IMAGE_BASE_INSTALL += " qcacld32-ll-congo net-tools sysstat "

#BAD_RECOMMENDATIONS += " \
#    linux-firmware-ath11k-qca6698aq \
#    linux-firmware-ath11k-wcn6855 \
#    linux-firmware-ath12k-wcn7850 \
#"
#
#remove_stock_wlan_modules() {
#    rm -rf ${IMAGE_ROOTFS}${nonarch_base_libdir}/modules/*/kernel/drivers/net/wireless/ath
#}
#ROOTFS_POSTPROCESS_COMMAND += "remove_stock_wlan_modules;"

