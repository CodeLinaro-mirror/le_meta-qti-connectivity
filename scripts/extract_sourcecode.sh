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

    if [ -d ${SRC_DIR}/${GIT_NAME} ]; then
        #Source Code already downloaded.
        return 0
    fi

    echo "Downloading ${GIT_NAME}"
    execute_command "pushd ${SRC_DIR}"
    execute_command "git clone ${GIT_URL}"
    execute_command "popd"

    if [ ! -d ${SRC_DIR}/${GIT_NAME} ]; then
        echo "Download ${GIT_NAME} failed from ${GIT_URL}"
        return 1
    fi

    if [ ! -z ${GIT_REV} ]; then
        execute_command "pushd ${SRC_DIR}/${GIT_NAME}"
        execute_command "git checkout ${GIT_REV}"
        execute_command "popd"
    fi
    echo "Download ${GIT_NAME} completed"
}

META_FSL_GIT="git://git.yoctoproject.org/meta-freescale"

META_FSL_3RD_GIT="https://github.com/Freescale/meta-freescale-3rdparty"

META_FSL_DIS_GIT="https://github.com/Freescale/meta-freescale-distro"

META_FSL_BROWSER_GIT="https://github.com/OSSystems/meta-browser"

if [ $PROJECTID == 'QCA6595AULE01' ]; then
	if [ $MACHINE == 'imx8mqevk' ]||[ $MACHINE == 'imx8qxpmek' ]||[ $MACHINE == 'imx8qxpc0mek' ]; then
		if [ $KERNELVERSION == "4.9" ]; then
			META_FSL_REV="49ac225a38f6d84519798e3264f2e4d19b84f70a"
			META_FSL_3RD_REV="1d6d5961dbf82624b28bb318b4950a64abc31d12"
			META_FSL_DIS_REV="0ec6d7e206705702b5b534611754de0787f92b72"
			META_FSL_BROWSER_REV="d6f9aed41c73b75a97d71bff060b03a66ee087b1"

			download_git_code ${META_FSL_BROWSER_GIT} ${META_FSL_BROWSER_REV}
			download_git_code ${META_FSL_GIT} ${META_FSL_REV}
			download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
			download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
		elif [ $KERNELVERSION == "4.14" ]; then
			META_FSL_REV="86772601e7f6ea188dfaf64097edafc05e15aef3"
			META_FSL_3RD_REV="82037216280a39957fb4272581637abec734ad50"
			META_FSL_DIS_REV="f7e2216e93aff14ac32728a13637a48df436b7f4"
			META_FSL_BROWSER_REV="75640e14e325479c076b6272b646be7a239c18aa"
			
			download_git_code ${META_FSL_BROWSER_GIT} ${META_FSL_BROWSER_REV}
			download_git_code ${META_FSL_GIT} ${META_FSL_REV}
			download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
			download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
		fi
	fi
elif [ $MACHINE == 'imx8mqevk' ]; then
	META_FSL_REV="407c6cf408969445031a492e2d25e0e2749582ea"
	META_FSL_3RD_REV="88a29631809d1af0df618245430db29f2a7012b5"
	META_FSL_DIS_REV="f7e2216e93aff14ac32728a13637a48df436b7f4"
	META_FSL_BROWSER_REV="75640e14e325479c076b6272b646be7a239c18aa"
	download_git_code ${META_FSL_BROWSER_GIT} ${META_FSL_BROWSER_REV}
	download_git_code ${META_FSL_GIT} ${META_FSL_REV}
	download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
	download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
elif [ $PROJECTID == 'QCA6574AULE221' ]; then
	META_FSL_REV="a398b50b7fc084a9e68cc3000c218d5028522a25"
	META_FSL_3RD_REV="68314612e236cab1da82d72a0da62635a3523f84"
	META_FSL_DIS_REV="cd5c7a2539f40004f74126e9fdf08254fd9a6390"
	download_git_code ${META_FSL_GIT} ${META_FSL_REV}
	download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
	download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
elif [ $PROJECTID == 'QCA6584AULE201' ]; then
	META_FSL_ARM_EXTRA_REV="c95f3f8b5b347f1b3e77d2d11063207ddb7dc5ec"
	META_FSL_DEMOS_REV="f141c7d1158b8addbd6f1ed047a1b47c2ed85f8f"
	download_git_code ${META_FSL_3RD_GIT} ${META_FSL_ARM_EXTRA_REV}
	download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DEMOS_REV}
	cp ${WORK_SPACE}/sources/meta-freescale-3rdparty  ${WORK_SPACE}/sources/meta-fsl-arm-extra -rf
	cp ${WORK_SPACE}/sources/meta-freescale-distro    ${WORK_SPACE}/sources/meta-fsl-demos -rf
fi
