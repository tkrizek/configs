#!/bin/bash

EXTERNAL='DP-3-2'
LCD='eDP-1'

# Is external screen connected?
xrandr | grep "${EXTERNAL} connected" > /tmp/dock_helper.log 2>&1
if [ $? -eq 0 ]; then
    # if external is connected -> turn off LCD, turn on external
    xrandr --output ${LCD} --off >> /tmp/dock_helper.log 2>&1
    xrandr --output ${EXTERNAL} --auto --primary >> /tmp/dock_helper.log 2>&1

    # alternative - duplicate
    # xrandr --output ${LCD} --auto --output ${EXTERNAL} --auto --same-as ${LCD} >> /tmp/dock_helper.log 2>&1
else
    # no external is connected -> turn on LCD only
    xrandr --output ${EXTERNAL} --off >> /tmp/dock_helper.log 2>&1
    xrandr --output ${LCD} --auto --primary >> /tmp/dock_helper.log 2>&1
fi
