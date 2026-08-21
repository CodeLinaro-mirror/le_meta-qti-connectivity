#!/bin/sh

#Copyright (c) 2018-2021 The Linux Foundation. All rights reserved.

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

#Changes from Qualcomm Technologies, Inc. are provided under the following license:
#Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#SPDX-License-Identifier: BSD-3-Clause-Clear

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
        #echo "Source Code ${GIT_NAME} already downloaded "
        if [ ! -z ${GIT_REV} ]; then
            #echo "checkout to revision ${GIT_REV}"
            execute_command "pushd ${SRC_DIR}/${GIT_NAME}"
            execute_command "git checkout ${GIT_REV}"
            execute_command "popd"
        fi
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

META_FSL_GIT="https://github.com/Freescale/meta-freescale"
META_FSL_3RD_GIT="https://github.com/Freescale/meta-freescale-3rdparty"
META_FSL_DIS_GIT="https://github.com/Freescale/meta-freescale-distro"
META_NXP_IMX_GIT="https://github.com/nxp-imx/meta-imx"
META_NXP_BITBAKE_GIT="https://github.com/openembedded/bitbake"
META_NXP_OE_GIT="https://github.com/openembedded/openembedded-core"
META_NXP_YOCTO_GIT="https://git.yoctoproject.org/meta-yocto"
META_NXP_ARM_GIT="https://git.yoctoproject.org/meta-arm"
META_NXP_BROWSER_GIT="https://github.com/OSSystems/meta-browser"
META_NXP_CLANG_GIT="https://github.com/kraj/meta-clang"
META_NXP_EMBEDDED_GIT="https://github.com/openembedded/meta-openembedded"
META_NXP_QT6_GIT="https://github.com/YoeDistro/meta-qt6"
META_NXP_SECURITY_GIT="https://git.yoctoproject.org/meta-security"
META_NXP_VIRT_GIT="https://git.yoctoproject.org/meta-virtualization"



case ${KERNELVERSION} in
    "4.9")
        #For manifest: imx-4.9.11-1.0.0_ga
        META_FSL_REV="a398b50b7fc084a9e68cc3000c218d5028522a25"
        META_FSL_3RD_REV="68314612e236cab1da82d72a0da62635a3523f84"
        META_FSL_DIS_REV="cd5c7a2539f40004f74126e9fdf08254fd9a6390"
        ;;
    "4.14")
        #For mainfest: imx-4.14.78-1.0.0_ga
        META_FSL_REV="407c6cf408969445031a492e2d25e0e2749582ea"
        META_FSL_3RD_REV="88a29631809d1af0df618245430db29f2a7012b5"
        META_FSL_DIS_REV="f7e2216e93aff14ac32728a13637a48df436b7f4"
        ;;
    "4.19")
        #For manifest: imx-4.19.35-1.1.0.xml
        META_FSL_REV="2142f7ded1b3115ccc21f7575fd83e2376247193"
        META_FSL_3RD_REV="da422478d38e744283bcf61123c4a526396c7030"
        META_FSL_DIS_REV="d4e77ea682fa10d0d54a723b3d3099c44fc5e95c"
        ;;
    "5.4")
        #For manifest: imx-5.4.70-2.3.2.xml
        META_FSL_REV="14f1a630a47375432f93c556927b879b51d84c4e"
        META_FSL_3RD_REV="dbcc686f52c3c84db8cb86aa8973a4e373651b98"
        META_FSL_DIS_REV="ca27d12e4964d1336e662bcc60184bbff526c857"
        ;;
    "5.10")
        #For manifest: imx-5.10.72-2.2.0.xml
        META_FSL_REV="469d6c958c76ea235b3d3c1527e797ce3a7392e3"
        META_FSL_3RD_REV="f8150f3b37cb83cba1f9e2378e57bb63e02d4610"
        META_FSL_DIS_REV="e6daa26ba1f748326546063d63a085ae671827d9"
        ;;
    "6.1")
        #For manifest: imx-6.1.1-1.0.1.xml
        META_FSL_REV="09c47379218167dda9fb0098129909a667fea2ec"
        META_FSL_3RD_REV="96c1f6a6c2cad246687cd695e0873fcc6cdde935"
        META_FSL_DIS_REV="1069c2f210b18cd707a4d8a82140a684a42a4ff6"
        ;;
    "6.6")
        #For manifest: imx_6.6.52_2.2.0.xml
        META_FSL_REV="0627128b341cfb2bef7a0832ce8cac0ce1127f13"
        META_FSL_3RD_REV="6c063450d464eb2f380443c7d9af1b94ce9b9d75"
        META_FSL_DIS_REV="b9d6a5d9931922558046d230c1f5f4ef6ee72345"
        META_NXP_IMX_REV="rel_imx_6.6.52_2.2.0"
        ;;
    "6.12")
        #For manifest: imx-6.12.49-2.2.0.xml
        META_FSL_REV="3d2781ad200846183ee3f3391f49512d0ef1b529"
        META_FSL_3RD_REV="5ba0c7cfdba9bc7c4495f0cdf1c195f45b7164a6"
        META_FSL_DIS_REV="b9c3536b68271c420fe5de36fc284781ceaa32ab"
        META_NXP_IMX_REV="rel_imx_6.12.49_2.2.0"
        ;;
    "6.18")
        #For manifest: imx-6.18.20-2.0.0.xml
        META_FSL_REV="3949624f36cbc5b7fd4033ce5ef001d83fc1a3e9"
        META_FSL_3RD_REV="3358b11ef81d52b9c9972d454dd43c120cbbdaf5"
        META_FSL_DIS_REV="70b7591ecaa99cb6366f93ee05df7c38d94d724b"
        META_NXP_IMX_REV="rel_imx_6.18.20_2.0.0"
        META_NXP_OE_REV="42fa856a00ac16b2a7a83d7ecfa60a5be192b16c"
        META_NXP_BITBAKE_REV="a2dd9be788274d9c7280be5b1be5eb5c3990cf54"
        META_NXP_YOCTO_REV="904846ae078ee20de073040ebb77c86e19250f56"
	META_NXP_ARM_REV="4112fda50b814ad6e3cfaefe5cad78a83114599a"
	META_NXP_BROWSER_REV="407e3ac990f5ed466cb76e5002f918860503799c"
	META_NXP_CLANG_REV="78c5e12f08198f4f257a9348516d2103cd617c1d"
	META_NXP_EMBEDDED_REV="420222862f5a6d95023b8f5f3b7e1808b2264ef9"
	META_NXP_QT6_REV="3cd8b59a1303b3c079f5345c6b2555d1037925f6"
	META_NXP_SECURITY_REV="9265f142f3890df2d00d71d13b19e95a082707ed"
	META_NXP_VIRT_REV="022f4356d4a9b389f51472d40a9330aa59f6bb9a"
        ;;
    *)
        echo "Not supported kernel version ${KERNELVERSION}"
        return 1
        ;;
esac

download_git_code ${META_FSL_GIT} ${META_FSL_REV}
download_git_code ${META_FSL_3RD_GIT} ${META_FSL_3RD_REV}
download_git_code ${META_FSL_DIS_GIT} ${META_FSL_DIS_REV}
download_git_code ${META_NXP_IMX_GIT} ${META_NXP_IMX_REV}
download_git_code ${META_NXP_OE_GIT} ${META_NXP_OE_REV}
download_git_code ${META_NXP_BITBAKE_GIT} ${META_NXP_BITBAKE_REV}
download_git_code ${META_NXP_YOCTO_GIT} ${META_NXP_YOCTO_REV}
download_git_code ${META_NXP_ARM_GIT} ${META_NXP_ARM_REV}
download_git_code ${META_NXP_BROWSER_GIT} ${META_NXP_BROWSER_REV}
download_git_code ${META_NXP_CLANG_GIT} ${META_NXP_CLANG_REV}
download_git_code ${META_NXP_EMBEDDED_GIT} ${META_NXP_EMBEDDED_REV}
download_git_code ${META_NXP_QT6_GIT} ${META_NXP_QT6_REV}
download_git_code ${META_NXP_SECURITY_GIT} ${META_NXP_SECURITY_REV}
download_git_code ${META_NXP_VIRT_GIT} ${META_NXP_VIRT_REV}
