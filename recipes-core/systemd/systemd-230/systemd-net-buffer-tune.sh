# Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# Enlarge network stack buffer size to meet concurrency throughput testing scenarios.
echo performance > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo 8291456 > /proc/sys/net/core/wmem_default
echo 8291456 > /proc/sys/net/core/rmem_default
echo 8291456 > /proc/sys/net/core/rmem_max
echo 8291456 > /proc/sys/net/core/wmem_max
