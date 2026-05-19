#Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
#SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/bash

file_location=/var/crash2
file_num=`find ${file_location} -type f | wc -l`
max_file_num=10
if [ $file_num -ge $max_file_num ]; then
   find $file_location -name "*.dump" | xargs ls -rt | head -n 1 | xargs -i rm {}
fi
DEVPATH=$(readlink -f /sys/devices/virtual/devcoredump/devcd*)
timestamp=$(date +%F_%H-%M-%S)
dev=${DEVPATH##*/}
if [ "$1" == "host_rddm" ]; then
filename=${file_location}/qca-host-error_${dev}_${timestamp}.dump
elif [ "$1" == "fw_rddm" ]; then
filename=${file_location}/qca-fw-error_${dev}_${timestamp}.dump
elif [ "$1" == "fw_sram" ]; then
filename=$file_location}/qca-fw-sram_${dev}_${timestamp}.dump
fi
echo "${DEVPATH}" > ${filename}
echo "\n" > ${filename}
cat ${DEVPATH}/data > ${filename}
sync ${filename}
echo 1 > ${DEVPATH}/data
