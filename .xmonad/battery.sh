#!/bin/bash
PERCENT=`upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep '^    percentage:' | sed 's/[^0-9]*//' | sed s/%//`

if [[ $(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep '^    state:' | grep ' charging') ]];
then
    if [ $PERCENT != 100 ]
    then
    	echo -n "AC $PERCENT%"
    else
    	echo -n "AC"
    fi
else
    echo -n "$PERCENT%"
fi

echo ""
