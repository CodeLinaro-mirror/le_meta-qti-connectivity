#!/bin/sh

#Copyright (c) 2018, The Linux Foundation. All rights reserved.

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


# This script will extract all required open source code.
# . sources/meta-qti-connectivity/scripts/extract_sourcecode.sh

download_git_code()
{
    local GIT_URL=$1 GIT_REV=$2
    local GIT_NAME="" SRC_DIR=""

    if [ -z "$GIT_URL" ]; then
        echo "Invalid Git Url"
        return 1
    fi

    GIT_NAME=${GIT_URL##*/}
    SRC_DIR="${WORK_SPACE}/sources"

    cd ${SRC_DIR}
    git clone ${GIT_URL}
    if [ "$?" != "0" ] || [ ! -d ${GIT_NAME} ]; then
        echo "Failed to download git: ${GIT_URL}"
        return 1
    fi
    if [ ! -z ${GIT_REV} ]; then
        cd ${SRC_DIR}/${GIT_NAME}
        git checkout ${GIT_REV}
        if [ "$?" != "0" ]; then
            echo "Can't Checkout ${GIT_REV}"
            return 1
        fi
    fi
    cd ${CURDIR}
}

copy_source_code()
{
    if [ ! -d ${CURDIR}/../${FSLBSP}/sources ]; then
        echo "No FSL BSP Source Code Dir ${FSLBSP} found"
        return 1
    fi

    WORK_SPACE="${CURDIR}/../${FSLBSP}"
    for DIR in ${CURDIR}/*; do
        DIR_NAME="$(basename ${DIR})"
        if [ ! -e ${WORK_SPACE}/sources/${DIR_NAME} ]; then
            cp -rf ${DIR} ${WORK_SPACE}/sources/${DIR_NAME}
        fi
    done
}



CURDIR=`pwd`
CURDIRNAME="$(basename ${CURDIR})"
FSLBSP="fsl-community-bsp"

META_FSL_GIT="git://git.yoctoproject.org/meta-freescale"
META_FSL_REV="a398b50b7fc084a9e68cc3000c218d5028522a25"

META_FSL_3RD_GIT="git://github.com/Freescale/meta-freescale-3rdparty"
META_FSL_3RD_REV="68314612e236cab1da82d72a0da62635a3523f84"

META_FSL_DIS_GIT="git://github.com/Freescale/meta-freescale-distro"
META_FSL_DIS_REV="cd5c7a2539f40004f74126e9fdf08254fd9a6390"


if [ ${CURDIRNAME} == ${PROJECTID} ]; then
    copy_source_code
else
    download_git_code ${META_FSL_GIT} ${META_FSL_REV}
    download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
    download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
fi
