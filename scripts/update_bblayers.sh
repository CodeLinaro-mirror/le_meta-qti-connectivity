#!/bin/sh

#Copyright (c) 2018-2021, The Linux Foundation. All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are
#met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials provided
#      with the distribution.
#    * Neither the name of The Linux Foundation nor the names of its
#      contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
#WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
#ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#Changes from Qualcomm Innovation Center are provided under the following license:
#
#Copyright (c) 2022-2024 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear

# This script tries to update conf/bblayers.conf for different project.

LCONF_VER=6

generate_common_bblayers()
{
    cat >> ${BBLAYERS_CONF} <<EOF
LCONF_VERSION = "${LCONF_VER}"

BBPATH = "\${TOPDIR}"
BSPDIR := "\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}"

BBFILES ?= ""
BBLAYERS = " \\
  \${BSPDIR}/sources/poky/meta \\
  \${BSPDIR}/sources/poky/meta-poky \\
  \\
  \${BSPDIR}/sources/meta-openembedded/meta-oe \\
  \${BSPDIR}/sources/meta-openembedded/meta-multimedia \\
  \${BSPDIR}/sources/meta-openembedded/meta-gnome \\
  \${BSPDIR}/sources/meta-openembedded/meta-networking \\
  \${BSPDIR}/sources/meta-openembedded/meta-python \\
  \${BSPDIR}/sources/meta-openembedded/meta-filesystems \\
  \\
  \${BSPDIR}/sources/meta-browser \\
"
EOF
}


bblayers_for_fsl_meta()
{
    local FSL_BSP_DIR="meta-imx"

    if [ ! -d "${WORK_SPACE}/sources/$FSL_BSP_DIR" ]; then
        FSL_BSP_DIR="meta-fsl-bsp-release/imx"
    fi

    cat >> ${BBLAYERS_CONF} <<EOF

##Freescale Yocto Project Release layer
BBLAYERS += " \${BSPDIR}/sources/meta-freescale "
BBLAYERS += " \${BSPDIR}/sources/meta-freescale-3rdparty "
BBLAYERS += " \${BSPDIR}/sources/meta-freescale-distro "

EOF

    case ${KERNELVERSION} in
        "4.1" | "4.9")
            sed -e "s/meta-poky/meta-yocto/g" -i ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> ${BBLAYERS_CONF}
            ;;
        "4.14")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> ${BBLAYERS_CONF}
            # Do noting.
            ;;
        "4.19")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-ml \"" >> ${BBLAYERS_CONF}
            echo "" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-rust \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> ${BBLAYERS_CONF}
            ;;
        "5.4")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-ml \"" >> ${BBLAYERS_CONF}
            echo "" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-rust \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-clang \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> ${BBLAYERS_CONF}
            ;;
        "5.10")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-ml \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-v2x \"" >> ${BBLAYERS_CONF}
            echo "" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-clang \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-python2 \""  >> ${BBLAYERS_CONF}
            sed -e "s/meta-browser/meta-browser\/meta-chromium/g" -i ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt5 \"" >> ${BBLAYERS_CONF}
            #echo "BBLAYERS += \" \${BSPDIR}/sources/meta-virtualization \""  >> ${BBLAYERS_CONF}
            ;;
        "6.1")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-bsp \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-sdk \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-ml \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-v2x \"" >> ${BBLAYERS_CONF}
            echo "" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-arm/meta-arm \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-arm/meta-arm-toolchain \""  >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-clang \"" >> ${BBLAYERS_CONF}
            sed -e "s/meta-browser/meta-browser\/meta-chromium/g" -i ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt6 \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-security/meta-parsec \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-security/meta-tpm \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-virtualization \""  >> ${BBLAYERS_CONF}
            ;;
        "6.6")
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-imx-bsp\"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-imx-sdk\"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-imx-ml\"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/${FSL_BSP_DIR}/meta-imx-v2x\"" >> ${BBLAYERS_CONF}
            echo "" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-arm/meta-arm \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-arm/meta-arm-toolchain \""  >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-clang \"" >> ${BBLAYERS_CONF}
            sed -e "s/meta-browser/meta-browser\/meta-chromium/g" -i ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-qt6 \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-security/meta-parsec \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-security/meta-tpm \"" >> ${BBLAYERS_CONF}
            echo "BBLAYERS += \" \${BSPDIR}/sources/meta-virtualization \""  >> ${BBLAYERS_CONF}
            ;;
        *)
            echo "Not supported kernel version ${KERNELVERSION}"
            ;;
    esac
}

bblayers_for_qti_meta()
{
    cat >> ${BBLAYERS_CONF} <<EOF

##QTI Yocto Connecetivity layer
BBLAYERS += " \${BSPDIR}/sources/meta-qti-connectivity "
BBLAYERS += " \${BSPDIR}/sources/meta-qti-connectivity-prop "

EOF

    #Update BBMASK bbfiles
    if [ -f "${WORK_SPACE}/sources/meta-qti-connectivity/conf/standalone-bbmask.conf" ]; then
        cat ${WORK_SPACE}/sources/meta-qti-connectivity/conf/standalone-bbmask.conf >> ${BBLAYERS_CONF}
    fi

    echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_3.10.17.bbappend"' >> ${BBLAYERS_CONF}

    if [ "${KERNELVERSION}" == "4.19" ]; then
        echo 'BBMASK.="|meta-qti-connectivity/recipes-core/busybox/busybox_%.bbappend"' >> ${BBLAYERS_CONF}
    fi

    if [ "${KERNELVERSION}" == "5.10" ]; then
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_%.bbappend"' >> ${BBLAYERS_CONF}
    else
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_5.10.bbappend"' >> ${BBLAYERS_CONF}
    fi
    
    if [ "${KERNELVERSION}" == "6.1" ]; then
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_%.bbappend"' >> ${BBLAYERS_CONF}
        echo 'BBMASK.="|meta-imx/meta-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend"' >> ${BBLAYERS_CONF}
    else
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_6.1.bbappend"' >> ${BBLAYERS_CONF}
    fi
    if [ "${KERNELVERSION}" == "6.6" ]; then
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_%.bbappend"' >> ${BBLAYERS_CONF}
        echo 'BBMASK.="|meta-imx/meta-imx-bsp/recipes-connectivity/wpa-supplicant/wpa-supplicant_%.bbappend"' >> ${BBLAYERS_CONF}
    else
        echo 'BBMASK.="|meta-qti-connectivity/recipes-kernel/linux-kernel/linux-imx_6.6.bbappend"' >> ${BBLAYERS_CONF}
    fi
}

################################################################
#BBLAYERS_TEMPLATES=${WORK_SPACE}/sources/base/conf/bblayers.conf
#Current should in BUILD_DIR
BBLAYERS_CONF=conf/bblayers.conf

echo '' > ${BBLAYERS_CONF}
if [ "${KERNELVERSION}" == "6.6" ]; then
    LCONF_VER=7
fi

generate_common_bblayers
bblayers_for_fsl_meta
bblayers_for_qti_meta
