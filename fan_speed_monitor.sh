#!/bin/sh

monitor_fan_speed() {
    while :
    do
        CURRENT_SPEED=$(fanctrl -getfanspeed | grep -Eoi "[0-9]+$")
        if [ -n "$PREV_SPEED" ] && [ "$CURRENT_SPEED" != "$PREV_SPEED" ]
        then
            echo "$PREV_SPEED -> $CURRENT_SPEED ($(date +%s.%N))"
        fi
        PREV_SPEED=$CURRENT_SPEED
        sleep 0.05
    done
}

monitor_fan_speed >> monitor.txt &
