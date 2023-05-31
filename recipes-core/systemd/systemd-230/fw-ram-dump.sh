#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/bash

timestamp=$(date +%F_%H-%M-%S)
dev=${DEVPATH##*/}
filename=/var/log/qca-fw-error_${dev}_${timestamp}.dump
echo "${DEVPATH}" > ${filename}
echo "\n" > ${filename}
cat /sys/${DEVPATH}/data > ${filename}
sync ${filename}
echo 1 > /sys/${DEVPATH}/data
