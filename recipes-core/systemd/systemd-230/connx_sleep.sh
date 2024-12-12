#!/bin/sh
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

case $1/$2 in
  pre/*)
    echo "Entering into $2..."

    # Stop BT Service to power off the chip
    systemctl stop bt-hal-service.service

    # disable WLAN interface
    for iface in `iw dev | grep Interface | awk '{print $2}'`
    do
         ifconfig $iface down
    done
    ;;
  post/*)
    echo "Exiting from $2..."

    # Start BT Service to bootup the chip
    systemctl restart bt-hal-service.service

    # enable WLAN interface
    ifconfig wlan0 up
    ;;
esac
