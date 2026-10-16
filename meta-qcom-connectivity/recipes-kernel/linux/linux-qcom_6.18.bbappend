FILESEXTRAPATHS:prepend := "${THISDIR}/linux-qcom-6.18:"

SRC_URI:append:iq-9075-evk = " file://qti-connectivity.cfg"
SRC_URI:append:iq-9075-evk = " file://0001-arm64-dts-qcom-lemans-evk-add-cnss-fig-node.patch"
