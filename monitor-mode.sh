#!/bin/bash

EXTERNAL_OUTPUT_ONE="HDMI-1"
EXTERNAL_OUTPUT_TWO="DP-1"
INTERNAL_OUTPUT="eDP-1"

function isConnected {
    ! xrandr | grep "^$1" | grep disconnected
}

# if we don't have a file, start at zero
if [ ! -f "/tmp/monitor_mode.dat" ] ; then
  monitor_mode="INTERNAL"

# otherwise read the value from the file
else
  monitor_mode=`cat /tmp/monitor_mode.dat`
fi

if isConnected ${EXTERNAL_OUTPUT_ONE} && isConnected ${EXTERNAL_OUTPUT_TWO} ; then
    if [ ${monitor_mode} = "INTERNAL" ]; then
        monitor_mode="EXTERNAL_ONE"
        xrandr --output ${INTERNAL_OUTPUT} --off --output ${EXTERNAL_OUTPUT_ONE} --auto --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "EXTERNAL_ONE" ]; then
        monitor_mode="EXTERNAL_TWO"
        xrandr --output ${INTERNAL_OUTPUT} --off --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --auto
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "EXTERNAL_ONE" ]; then
        monitor_mode="EXTERNAL_ONE_AND_TWO"
        xrandr --output ${INTERNAL_OUTPUT} --off --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --auto
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "EXTERNAL_TWO" ]; then
        monitor_mode="ALL"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --auto --right-of ${INTERNAL_OUTPUT} --output ${EXTERNAL_OUTPUT_ONE} --auto --right-of ${EXTERNAL_OUTPUT_ONE}
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    else
        monitor_mode="INTERNAL"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    fi
elif isConnected ${EXTERNAL_OUTPUT_ONE} ; then
    if [ ${monitor_mode} = "INTERNAL" ]; then
        monitor_mode="EXTERNAL_ONE"
        xrandr --output ${INTERNAL_OUTPUT} --off --output ${EXTERNAL_OUTPUT_ONE} --auto --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "EXTERNAL_ONE" ]; then
        monitor_mode="CLONES_ONE"
        F
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "CLONES_ONE" ]; then
        monitor_mode="INTERNAL_AND_EXTERNAL_ONE"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --auto --right-of ${INTERNAL_OUTPUT}  --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    else
        monitor_mode="INTERNAL"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    fi
elif isConnected ${EXTERNAL_OUTPUT_TWO} ; then
    if [ ${monitor_mode} = "INTERNAL" ]; then
        monitor_mode="EXTERNAL_TWO"
        xrandr --output ${INTERNAL_OUTPUT} --off --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --auto
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "EXTERNAL_TWO" ]; then
        monitor_mode="CLONES_TWO"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_TWO} --auto --same-as ${INTERNAL_OUTPUT} --output ${EXTERNAL_OUTPUT_ONE} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    elif [ ${monitor_mode} = "CLONES_TWO" ]; then
        monitor_mode="INTERNAL_AND_EXTERNAL_TWO"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_TWO} --auto --right-of ${INTERNAL_OUTPUT}  --output ${EXTERNAL_OUTPUT_ONE} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    else
        monitor_mode="INTERNAL"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
    fi
else
        monitor_mode="INTERNAL"
        xrandr --output ${INTERNAL_OUTPUT} --auto --output ${EXTERNAL_OUTPUT_ONE} --off --output ${EXTERNAL_OUTPUT_TWO} --off
        notify-send --icon=gtk-info "Monitor mode" "Mode: ${monitor_mode}"
fi

echo "${monitor_mode}" > /tmp/monitor_mode.dat