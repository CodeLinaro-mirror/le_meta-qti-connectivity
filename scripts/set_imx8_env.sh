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


# Setup Standalone Automotive BSP environment.
# Create softlink in BSP to QTI connectivity release codes if available.
# Update BSP configuration parameters.
# Export QTI Software Product specific PROJECTID.

#Changes from Qualcomm Innovation Center are provided under the following license:
#Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear

umask 022

usage()
{
    local SCRIPT_PARAMS="[EULA=<eula>] [MACHINE=<machine>] [PROJECT=<projectid>] [ADDON=<name>]"
    echo
    echo "script usage for QTI Standalone Auto image"
    echo "${SCRIPT_PARAMS} source ${SCRIPT_FILE} [BUILDDIR]"
    echo "For example: PROJECT=QCA67x7AULE11 source ${SCRIPT_FILE}"
    echo
    echo "EULA      :  FSL EULA, default 0 if undefined."
    echo "BUILDDIR  :  the build directory location, 'build' by default."
    echo "MACHINE   :  Supported machines, 'imx8qxpc0mek' by default. reference command \$list_machines"
    echo "PROJECT   :  Supported QTI Standalone SP"
    echo "ADDON     :  Connectivity add-on feature names (separate in space)."
    echo "QCA67x7AULE11 : QCA67x7AU.LE.1.1 SP"
}

execute_command()
{
    eval "$1  > /dev/null 2>&1"

    if [ ! $? -eq 0 ]; then
        echo "Command execution failed: '$1'. Terminating..."
        exit 1
    fi
}

cleanenv()
{
    unset EULA MACHINE PROJECT DISTRO ADDON
}

list_machines()
{
    echo "Supported Machines by this BSP:"
    echo; ls ${WORK_SPACE}/sources/*/conf/machine/*.conf  ${WORK_SPACE}/sources/meta-imx/*/conf/machine/*.conf| \
    sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"
    echo
}

check_machine_valid()
{
    local MACHINES=`ls -1 ${WORK_SPACE}/sources/*/conf/machine ${WORK_SPACE}/sources/meta-imx/*/conf/machine`
    local VALID_MACHINE=`echo -e "${MACHINES}" | grep ${MACHINE}.conf$ | wc -l`
    if [ "$VALID_MACHINE" = "0" ]; then
        echo -e "\nThe MACHINE=$MACHINE is not supported by this build setup"
        list_machines
        return 1
    fi
}

get_bsp_kernel_version()
{
    local BBFILE
    local DIR

    DIR=${WORK_SPACE}/sources/meta-fsl-bsp-release
    if [ -d ${WORK_SPACE}/sources/meta-imx ]; then
        DIR=${WORK_SPACE}/sources/meta-imx
    fi

    if [ ! -d ${DIR} ]; then
        echo "bsp dir not exist"
        return 1
    fi

    BBFILE="$(find ${DIR} -name "linux-imx_*.bb")"
    KERNELVERSION="$(echo ${BBFILE##*linux-imx_} | awk -F '.' 'BEGIN{OFS="."}{print $1,$2}')"
}

buildclean()
{
    set -x
    cd ${WORK_SPACE}/${BUILD_DIR}
    rm -rf bitbake.lock pseudodone sstate-cache tmp/* cache && cd - || cd -
    set +x
}

cdbitbake()
{
    local ret=0
    cd ${WORK_SPACE}/${BUILD_DIR}
    bitbake $@ && cd - || ret=$? && cd -
    return $ret
}

rebake()
{
    cdbitbake -c cleanall $@ && \
    cdbitbake $@
}

build-imxauto-image()
{
    cdbitbake standalone-imx8auto-image
    if [ "$?" != "0" ]; then
        echo "Error run building image."
        return 1
    fi
}

############################################################################
#Exec Commands:

# Set default sripts and work space path
SCRIPT_FOLDER="$(dirname "${BASH_SOURCE}")"
WORK_SPACE=$(readlink -f ${SCRIPT_FOLDER}/../../..)
SCRIPT_FILE=${SCRIPT_FOLDER}/set_imx8_env.sh

EULA_REMIND_LOG=" To contiune the build process, you have to set EULA=1 \n"

cat  << EOF
IMPORTANT NOTICE:
Use of the set_imx8_env.sh script will combine some open source licensed software and/or third party licensed software
components into the product. Redistribution and use of the open source and/or third party code
may legally require you to comply with the terms of the open source and/or third party license(s)
that apply to the code used and redistributed."

EOF

case $EULA in
    "1")
        ;;
    *)
        {
            echo -e ${EULA_REMIND_LOG}
            cleanenv
            return 1
        } ;;
esac



case $PROJECT in
    "QCA67x7AULE11" | "")
        {
            DISTRO=fsl-imx-xwayland
            export PROJECTID=QCA67x7AULE11
        } ;;
    *)
        {
            echo "Invalid PROJECT, check script usage"
            usage
            cleanenv
            return 1
        } ;;
esac

FEATURE_CNSS_STANDALONE="0"

addons=(${ADDON//''/ })
for feature in ${addons[@]}
do
    case $feature in
        "CNSS_STANDALONE")
            {
                FEATURE_CNSS_STANDALONE="1"
            } ;;
        *)
            {
                echo "Unsupported addon $feature!!!"
                usage
                cleanenv
                return 1
            } ;;
    esac
done

# Default MACHINE
if [[ -z "$MACHINE" || $MACHINE == "imx8qxpc0mek" || $MACHINE == "imxauto" ]]; then
    MACHINE='imx8qxpc0mek'
elif [ "$MACHINE" == "imx8mqevk" ]; then
    MACHINE='imx8mqevk'
elif [ "$MACHINE" == "imx8qxpmek" ]; then
    MACHINE='imx8qxpmek'
else
    check_machine_valid
    if [ "$?" != "0" ]; then
        cleanenv
        return 1
    fi
fi

# Get current BSP kernel version
#get_bsp_kernel_version
#if [ -z "${KERNELVERSION}" ]; then
#    echo "Can't find linux kernel bbfile, use 6.6 by default"
#    KERNELVERSION="6.6"
#fi

KERNELVERSION="6.6"

# Get all required source codes.
. ${SCRIPT_FOLDER}/extract_sourcecode.sh

#Default build-dir
BUILD_DIR=$1
if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR='build'
fi

# Cleanup previous meta-freescale/EULA overrides
pushd ${WORK_SPACE}/sources/meta-freescale
if [ -h EULA ]; then
    echo Cleanup meta-freescale/EULA...
    git checkout -- EULA
fi
if [ ! -f classes/fsl-eula-unpack.bbclass ]; then
    echo Cleanup meta-freescale/classes/fsl-eula-unpack.bbclass...
    git checkout -- classes/fsl-eula-unpack.bbclass
fi
popd

# Override the click-through in meta-freescale/EULA
FSL_EULA_FILE=$CWD/sources/meta-imx/EULA.txt

#Default DISTRO
if [ -z "$DISTRO" ]; then
    DISTRO=fsl-imx-xwayland
fi

. ${WORK_SPACE}/sources/poky/oe-init-build-env ${BUILD_DIR} > /dev/null

# Generate the local.conf based on the Yocto defaults
# Update local.conf based on Yocto
mv conf/local.conf conf/local.conf.sample
grep -v '^#\|^$' conf/local.conf.sample > conf/local.conf
sed -e "s,MACHINE ??=.*,MACHINE ??= '$MACHINE',g" \
    -e "s,DISTRO ?=.*,DISTRO ?= '$DISTRO',g" \
    -i conf/local.conf

if grep -q '^DL_DIR ?=' conf/local.conf; then
    sed -e "s,^DL_DIR ?=.*,DL_DIR ?= \"\${BSPDIR}/downloads/\",g" -i conf/local.conf
else
    echo "DL_DIR ?= \"\${BSPDIR}/downloads/\"" >> conf/local.conf
fi

if grep -q '^ACCEPT_FSL_EULA\s*=' conf/local.conf; then
    sed -e "s/^ACCEPT_FSL_EULA\s*=.*/ACCEPT_FSL_EULA = \"$EULA\"/g" -i conf/local.conf
else
    echo "ACCEPT_FSL_EULA = \"$EULA\"" >> conf/local.conf
fi

echo >> conf/local.conf
echo "# Switch to Debian packaging and include package-management in the image" >> conf/local.conf
echo "PACKAGE_CLASSES = \"package_deb\"" >> conf/local.conf
echo "EXTRA_IMAGE_FEATURES += \"package-management\"" >> conf/local.conf

# Export specific parameters for Yocto
if grep -q 'PROJECTID' conf/local.conf; then
    sed -e "s/^PROJECTID\s*=.*/PROJECTID = \"$PROJECTID\"/g" -i conf/local.conf
else
    echo "PROJECTID = \"$PROJECTID\"" >> conf/local.conf
fi

if grep -q 'KERNELVERSION' conf/local.conf; then
   sed -e "s/^KERNELVERSION\s*=.*/KERNELVERSION = \"$KERNELVERSION\"/g" -i conf/local.conf
else
   echo "KERNELVERSION = \"$KERNELVERSION\"" >> conf/local.conf
fi

if grep -q 'FEATURE_CNSS_STANDALONE' conf/local.conf; then
   sed -e "s/^FEATURE_CNSS_STANDALONE\s*=.*/FEATURE_CNSS_STANDALONE = \"$FEATURE_CNSS_STANDALONE\"/g" -i conf/local.conf
else
   echo "FEATURE_CNSS_STANDALONE = \"$FEATURE_CNSS_STANDALONE\"" >> conf/local.conf
fi
# Update bblayers.conf
. ${WORK_SPACE}/${SCRIPT_FOLDER}/update_bblayers.sh

#Workaround to fix KW build Error by remove "ERROR" in poky/meta/lib/oe/rootfs.py
#The "ERROR" will be tracked by log check, which will make build failed.
ROOTFSFILE=${WORK_SPACE}/sources/poky/meta/lib/oe/rootfs.py
sed -e "s/ERROR: |Error: |Error |ERROR/Error: |Error/g" -i ${ROOTFSFILE}

# Apply patches to 3rd codes
. ${WORK_SPACE}/${SCRIPT_FOLDER}/apply_patch.sh

cleanenv

cat <<EOF

Welcome to Freescale Community BSP with QTI Connectivity Product

You can now run commands to build image:

    build-imxauto-image

EOF
