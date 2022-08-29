#!/bin/sh
# Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted (subject to the limitations in the
# disclaimer below) provided that the following conditions are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#
#     * Neither the name of Qualcomm Innovation Center, Inc. nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE
# GRANTED BY THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
# HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

. ./install_qcwlan_common.sh

validate()
{
	if [ ! -d ${CONF_DIR} ]; then
		clog ${RED} "please put scripts in the root folder"
		exit 1
	else
		return 0
	fi
}

clean()
{
	bbconf=${CONF_DIR}/.bblayers.conf
	if [ -f ${bbconf} ]; then
		clog ${GREEN} "restore bblayers.conf"
		mv ${bbconf} ${CONF_DIR}/bblayers.conf
	fi

	localconf=${CONF_DIR}/.local.conf
	if [ -f ${localconf} ]; then
		clog ${GREEN} "restore local.conf"
		mv ${localconf} ${CONF_DIR}/local.conf
	fi

	path="${SRC_DIR}/meta-ti/recipes-kernel/linux"
	setupcfgfile="${path}/.setup-defconfig.inc"
	kbbfile="${path}/.linux-ti-staging_5.10.bb"

	if [ -f ${setupcfgfile} ]; then
		clog ${GREEN} "restore setup-defconfig.inc"
		mv ${setupcfgfile} ${path}/setup-defconfig.inc
	fi

	if [ -f ${kbbfile} ]; then
		clog ${GREEN} "restore linux-ti-staging_5.10.bb"
		mv ${kbbfile} ${path}/linux-ti-staging_5.10.bb
	fi
}

update_product_bb()
{
	productbb=${SRC_DIR}/meta-arago/meta-arago-distro/recipes-core/images/tisdk-default-image.bb
	clog ${GREEN} "update tisdk-default-image.bb"
	sed -e "/packagegroup-arago-tisdk-connectivity/d" -i ${productbb}
}

clone_wireless_tools()
{
	mkdir -p ${ROOT_DIR}/../.tmp/
	cd ${ROOT_DIR}/../.tmp
	clog ${GREEN} "clone wireless-tools"
	git clone -b poky/master https://source.codeaurora.org/quic/ype/external/yoctoproject.org/poky
	cd -
}

copy_wireless_tools()
{
	if [ ! -d ${SRC_DIR} ]; then
		clog ${RED} "Can't find ${SRC_DIR}"
		return -1
	fi

	toolpath=${SRC_DIR}/oe-core/meta/recipes-connectivity

	if [ -d "${toolpath}/wireless-tools" ]; then
		#echo "wireless tool already present"
		return 0
	fi

	clog ${GREEN} "copy wireless tool bb"
	if [ "${WTOOL_SRC_PATH}" == "" ]; then
		clone_wireless_tools
		WTOOL_SRC_PATH=${ROOT_DIR}/../.tmp/poky/meta/recipes-connectivity/wireless-tools
	fi
	cp -fr ${WTOOL_SRC_PATH} ${toolpath}
}

trim_qcwlan()
{
	clog ${GREEN} "Trim qcwlan source code"
	#remove recipes-core  recipes-kernel  recipes-products  scripts
	rm -fr ${SRC_DIR}/meta-qti-connectivity/recipes-core/*
	rm -fr ${SRC_DIR}/meta-qti-connectivity/recipes-kernel/*
	rm -fr ${SRC_DIR}/meta-qti-connectivity/recipes-products/*
	return 0
}

update_qcwlan_bb()
{
	bbfile="${SRC_DIR}/meta-qti-connectivity/recipes-connectivity/wlan-driver/wlan-cnss-core_1.0.bb"
	if [ ! -f "${bbfile}" ]; then
		clog ${RED} "Can't find ${bbfile}"
		return 1
	fi

	clog ${GREEN} "update wlan-cnss-core_1.0.bb"
	sed -e "s/^LICENSE\s*=.*/LICENSE = \"GPL-2.0\"/g" -i ${bbfile}
	sed -e "s/^LIC_FILES_CHKSUM\s*=.*/LIC_FILES_CHKSUM = \"file:\/\/\${COMMON_LICENSE_DIR}\/\${LICENSE};md5=801f80980d171dd6425610833a22dbe6\"/g" -i ${bbfile}
	return 0
}

update_kernel_bb()
{
	bbappend="${SRC_DIR}/meta-arago/meta-arago-distro/recipes-kernel/linux/linux-ti-staging_%.bbappend"
	patchname="0001-wlan-hsp-dts-for-j7200-k3.patch"
	if [ ! -f ${bbappend} ]; then
		clog ${RED} "Can't find ${bbappend}"
		return 1
	fi

	name=`cat ${bbappend} | grep ${patchname}`
	if [ -n "${name}" ]; then
		#clog ${RED} "${bbappend} already patched"
		return 0
	fi

	clog ${GREEN} "adding qcwlan kernel patch"
	cat >> ${bbappend} << EOF
SRC_URI += "file://0001-wlan-hsp-dts-for-j7200-k3.patch"
EOF
}

generate_wlan_kernel_patch()
{
	patchname="0001-wlan-hsp-dts-for-j7200-k3.patch"
	patchfile="${SRC_DIR}/meta-arago/meta-arago-distro/recipes-kernel/linux/linux-ti-staging/${patchname}"

	if [ -f ${patchfile} ]; then
		#clog ${RED} "wlan kernel patch already generated"
		return 0
	fi

	clog ${GREEN} "Install ${patchname}"
	cp -fr ${patchname} ${patchfile}
}

custom_kernel_config()
{
	clog ${GREEN} "Customize kernel config"
	path="${SRC_DIR}/meta-ti/recipes-kernel/linux"
	setupcfgfile="${path}/setup-defconfig.inc"
	kbbfile="${path}/linux-ti-staging_5.10.bb"

	if [ ! -f "${path}/.setup-defconfig.inc" ]; then
		cp ${setupcfgfile} ${path}/.setup-defconfig.inc
		# patch setup-defconfig.inc
		sed -e '/tree config/acp -fr ${WORKDIR}/connectivity.cfg ${S}/ti_config_fragments/' -i ${setupcfgfile}
	fi

	if [ ! -f "${path}/.linux-ti-staging_5.10.bb" ]; then
		cp ${kbbfile} ${path}/.linux-ti-staging_5.10.bb
		# patch linux-ti-staging_5.10.bb
		sed -e '/file:\/\/defconfig/aSRC_URI += "file://connectivity.cfg"' -i ${kbbfile}
	fi

	# Install addon wlan kernel cfg
	cp -fr connectivity.cfg ${path}/linux-ti-staging-5.10/
}

fix_vendor_issue()
{
	if [ -f fix_vendor_issue.sh ]; then
		clog ${GREEN} "fix_vendor_issue $1"
		sh fix_vendor_issue.sh $1
	fi
}

update_bblayer()
{
	bbconf=${CONF_DIR}/bblayers.conf
	if [ ! -f "${bbconf}" ]; then
		clog ${RED} "Can't find ${bbconf}"
		return 1
	fi
	# avoid to do it again
	if [ -f "${CONF_DIR}/.bblayers.conf" ]; then
		#echo "bblayer already updated"
		return 0
	fi

	clog ${GREEN} "update bblayers"
	mv ${bbconf} ${CONF_DIR}/.bblayers.conf

	cat >> ${bbconf} << EOF
LCONF_VERSION = "7"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""
export BSPDIR := "\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}"
# Layers configured by oe-core-setup script
BBLAYERS += " \\
        \${BSPDIR}/sources/meta-qti-connectivity  \\
        \${BSPDIR}/sources/meta-arago/meta-arago-distro \\
        \${BSPDIR}/sources/meta-arago/meta-arago-extras \\
        \${BSPDIR}/sources/meta-psdkla \\
        \${BSPDIR}/sources/meta-qt5 \\
        \${BSPDIR}/sources/meta-virtualization \\
        \${BSPDIR}/sources/meta-openembedded/meta-networking \\
        \${BSPDIR}/sources/meta-openembedded/meta-python \\
        \${BSPDIR}/sources/meta-openembedded/meta-oe \\
        \${BSPDIR}/sources/meta-openembedded/meta-gnome \\
        \${BSPDIR}/sources/meta-openembedded/meta-filesystems \\
        \${BSPDIR}/sources/meta-ti \\
        \${BSPDIR}/sources/meta-arm/meta-arm \\
        \${BSPDIR}/sources/meta-arm/meta-arm-toolchain \\
        \${BSPDIR}/sources/oe-core/meta \\
        \${BSPDIR}/sources/meta-aws \\
        \${BSPDIR}/sources/meta-jupyter \\
"
BBMASK ="oe-core/meta/recipes-connectivity/wpa-supplicant/wpa-supplicant_2.9.bb"
BBMASK.="|meta-arago/meta-arago-extras/recipes-connectivity/wpa-supplicant/wpa-supplicant-wl18xx.bb"
BBMASK.="|meta-arago/meta-arago-extras/recipes-connectivity/hostap/hostap-daemon-wl18xx.bb"
BBMASK.="|meta-openembedded/meta-oe/recipes-connectivity/hostapd/hostapd_2.9.bb"
BBMASK.="|meta-arago/meta-arago-distro/recipes-core/packagegroups/packagegroup-arago-tisdk-connectivity.bb"

EOF
	return 0
}

update_localconf()
{
	localconf=${CONF_DIR}/local.conf

	if [ ! -f "${localconf}" ]; then
		clog ${RED} "Can't find ${localconf}"
		return 1
	fi

	# avoid to do it again
	if [ -f "${CONF_DIR}/.local.conf" ]; then
		#echo "locol already updated"
		return 0
	fi

	clog ${GREEN} "update localconf"
	cp ${localconf} ${CONF_DIR}/.local.conf

	cat >> ${localconf} << EOF

MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "wpa-supplicant"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "wlan-cnss-core"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "qcacld32-ll-hsp"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "pciutils"
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS += "wireless-tools"

EOF
	return 0
}

# start main
if [ "$1" == "clean" ]; then
	clean
	fix_vendor_issue clean
	exit 0
fi

validate
copy_wireless_tools
update_bblayer
update_localconf
trim_qcwlan
update_qcwlan_bb
update_kernel_bb
generate_wlan_kernel_patch
update_product_bb
custom_kernel_config
fix_vendor_issue
