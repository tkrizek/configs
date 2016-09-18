#!/bin/bash

USERS=$(last | grep still | cut -d " " -f1 | uniq)

for user in "${USERS}"; do
    case "$1" in
        "0")
            #undocked event
            logger 'undocked event'
            DISPLAY=:0.0 su ${user} -c "bash /home/tkrizek/.xmonad/dock_helper.sh"
        ;;
        "1")
            #docked event
            logger 'docked event'
            DISPLAY=:0.0 su ${user} -c "bash /home/tkrizek/.xmonad/dock_helper.sh"
        ;;
    esac
done
exit 0
