#!/bin/bash

status=$(nordvpn status)

if [[ "$status" =~ "Status: Disconnected" ]] ;
then
    nordvpn c nz
else
    nordvpn disconnect
fi
