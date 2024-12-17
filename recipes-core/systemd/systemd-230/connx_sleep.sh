#!/bin/sh
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

case $1/$2 in
  pre/*)
    echo "Entering into $2..."

    # disable WLAN interface
    for iface in `iw dev | grep Interface | awk '{print $2}'`
    do
         ifconfig $iface down
    done
    ;;
  post/*)
    echo "Exiting from $2..."

    # enable WLAN interface
    ifconfig wlan0 up
    ;;
esac
