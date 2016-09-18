#!/bin/bash

FIRST_EXTERNAL='DP-3-2'
LCD_SCREEN='eDP-1'

logger 'Running dock/undock script'

# Start by activating the laptop screen
xrandr --output ${FIRST_EXTERNAL} --off > /tmp/dock_helper.log 2>&1
logger "Setting ${LCD_SCREEN} as primary monitor"
xrandr --output ${LCD_SCREEN} --auto --primary >> /tmp/dock_helper.log 2>&1

# Attempt to determine which external screens are attached
xrandr | grep "${FIRST_EXTERNAL} connected" >> /tmp/dock_helper.log 2>&1
if [ $? -eq 0 ]; then
    logger "Found ${FIRST_EXTERNAL}. Setting ${FIRST_EXTERNAL} as primary and placing ${LCD_SCREEN} to the left"
    xrandr --output ${FIRST_EXTERNAL} --auto --primary --output ${LCD_SCREEN} --auto --left-of ${FIRST_EXTERNAL} >> /tmp/dock_helper.log 2>&1
fi
