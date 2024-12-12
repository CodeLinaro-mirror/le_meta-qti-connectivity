#!/bin/sh
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

case $1/$2 in
  pre/*)
    echo "Entering into $2..."

    # Stop BT Service to power off the chip
    systemctl stop bt-hal-service.service

    ;;
  post/*)
    echo "Exiting from $2..."

    # Start BT Service to bootup the chip
    systemctl restart bt-hal-service.service

    ;;
esac
