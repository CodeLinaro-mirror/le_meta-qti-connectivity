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

CUR_DIR=`pwd`
# patches for ti-processor-sdk-linux-j7200-evm-08_02_00_02-Linux-x86 release
SRC_mobile_broadband="${SRC_DIR}/oe-core/meta/recipes-connectivity/mobile-broadband-provider-info"
SRC_meta_psdkla="${SRC_DIR}/meta-psdkla"

clean_vendor()
{
	cd ${SRC_mobile_broadband}
	if [ -f .qcpatched ]; then
		git reset --hard HEAD~1
		rm -fr .qcpatched
		cd -
	fi

	cd ${SRC_meta_psdkla}
	if [ -f .qcpatched ]; then
		git reset --hard HEAD~1
		rm -fr .qcpatched
		cd -
	fi
}

if [ "$1" == "clean" ]; then
	clean_vendor
	exit 0
fi

cd ${SRC_mobile_broadband}
if [ ! -f .qcpatched ]; then
	git am ${CUR_DIR}/0001-mobile-broadband-provider-build-patch.patch
	touch .qcpatched
fi
cd -

cd ${SRC_meta_psdkla}
if [ ! -f .qcpatched ]; then
	git am ${CUR_DIR}/0001-meta-psdkla-build-patch.patch
	touch .qcpatched
fi
cd -
