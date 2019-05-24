#!/bin/sh

#Copyright (c) 2018-2019, The Linux Foundation. All rights reserved.

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


# This script tries to update conf/bblayers.conf for different project.

generate_common_bblayers()
{
    cat <<EOF
LCONF_VERSION = "6"

BBPATH = "\${TOPDIR}"
export BSPDIR := "\${@os.path.abspath(os.path.dirname(d.getVar('FILE', True)) + '/../..')}"

BBFILES ?= ""
BBLAYERS = " \\
  \${BSPDIR}/sources/poky/meta \\
  \\
  \${BSPDIR}/sources/meta-openembedded/meta-oe \\
  \${BSPDIR}/sources/meta-openembedded/meta-multimedia \\
  \${BSPDIR}/sources/meta-openembedded/meta-gnome \\
  \${BSPDIR}/sources/meta-openembedded/meta-networking \\
  \${BSPDIR}/sources/meta-openembedded/meta-python \\
  \${BSPDIR}/sources/meta-openembedded/meta-filesystems \\
  \\
  \${BSPDIR}/sources/meta-browser \\
  \${BSPDIR}/sources/meta-qt5 \\
"
EOF
}


bblayers_for_qca6574aule221()
{
    cat >> ${BBLAYERS_CONF} <<EOF

##Freescale Yocto Project Release layer
BBLAYERS += " \${BSPDIR}/sources/meta-fsl-bsp-release/imx/meta-bsp "
BBLAYERS += " \${BSPDIR}/sources/meta-fsl-bsp-release/imx/meta-sdk "
BBLAYERS += " \${BSPDIR}/sources/meta-freescale-3rdparty "
BBLAYERS += " \${BSPDIR}/sources/meta-freescale-distro "
EOF

    # Support integrating community meta-freescale instead of meta-fsl-arm
    if [ -d ${WORK_SPACE}/sources/meta-freescale ]; then
        # Change settings according to environment
        echo "BBLAYERS += \" \${BSPDIR}/sources/meta-freescale \"" >> ${BBLAYERS_CONF}
    fi

    #Poky in imx-4.14.78-1.0.0_ga.xml only support meta-poky
    if [ -d ${WORK_SPACE}/sources/poky/meta-poky ]; then
	echo "BBLAYERS += \" \${BSPDIR}/sources/poky/meta-poky \""  >> ${BBLAYERS_CONF}
    fi

    #Poky in imx-4.1 or imx-4.9 support meta-yocto and meta-poky
    if [ -d ${WORK_SPACE}/sources/poky/meta-yocto ]; then
        echo "BBLAYERS += \" \${BSPDIR}/sources/poky/meta-yocto \""  >> ${BBLAYERS_CONF}
    fi

}

################################################################
#BBLAYERS_TEMPLATES=${WORK_SPACE}/sources/base/conf/bblayers.conf
#Current should in BUILD_DIR
BBLAYERS_CONF=conf/bblayers.conf
generate_common_bblayers > ${BBLAYERS_CONF}


cat >> ${BBLAYERS_CONF} <<EOF

##QTI Yocto Connecetivity layer
BBLAYERS += " \${BSPDIR}/sources/meta-qti-connectivity "
BBLAYERS += " \${BSPDIR}/sources/meta-qti-connectivity-prop "
EOF

case $1 in
    "QCA6574AULE221")
        {
            bblayers_for_qca6574aule221
        } ;;
esac

#Update BBMASK bbfiles
if [ -f "${WORK_SPACE}/sources/meta-qti-connectivity/conf/standalone-bbmask.conf" ]; then
    cat ${WORK_SPACE}/sources/meta-qti-connectivity/conf/standalone-bbmask.conf >> ${BBLAYERS_CONF}
fi
if [ -f "${WORK_SPACE}/sources/meta-qti-connectivity-prop/conf/standalone-prop-bbmask.conf" ]; then
    cat ${WORK_SPACE}/sources/meta-qti-connectivity-prop/conf/standalone-prop-bbmask.conf >> ${BBLAYERS_CONF}
fi

