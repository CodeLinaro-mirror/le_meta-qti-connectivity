#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/bash

DEVPATH=$(readlink -f /sys/devices/virtual/devcoredump/devcd*)
timestamp=$(date +%F_%H-%M-%S)
dev=${DEVPATH##*/}
if [ "$1" == "host_rddm" ]; then
filename=/var/crash/qca-host-error_${dev}_${timestamp}.dump
elif [ "$1" == "fw_rddm" ]; then
filename=/var/crash/qca-fw-error_${dev}_${timestamp}.dump
elif [ "$1" == "fw_sram" ]; then
filename=/var/crash/qca-fw-sram_${dev}_${timestamp}.dump
fi
echo "${DEVPATH}" > ${filename}
echo "\n" > ${filename}
cat ${DEVPATH}/data > ${filename}
sync ${filename}
echo 1 > ${DEVPATH}/data
