#!/bin/sh

# ##########################################################
# DISCLAIMER
# ##########################################################
# This script is provided as-is, without any warranty or
# guarantee of any kind. The author(s) assume no liability
# for any damage or loss caused by the use or misuse of
# this script. Use at your own risk.
#
# Before running this script, make sure to review and
# understand its functionality. The author(s) are not
# responsible for any unintended consequences resulting
# from the execution of this script.
#
# It is recommended to take appropriate precautions,
# including but not limited to, backup of data, testing
# in a controlled environment, and ensuring compatibility
# with your system configuration before using this script.
#
# By using this script, you agree that the author(s) shall
# not be held responsible for any issues that may arise
# during its use.
# ##########################################################
# Author: Erellariss

# temperature to power grid : GRIDxx=yy : we want power of yy if temp is xx
GRID15=31 ; GRID16=31 ; GRID17=31 ; GRID18=31 ; GRID19=31
GRID20=31 ; GRID21=31 ; GRID22=31 ; GRID23=31 ; GRID24=31
GRID25=31 ; GRID26=31 ; GRID27=31 ; GRID28=31 ; GRID29=31
GRID30=31 ; GRID31=31 ; GRID32=31 ; GRID33=50 ; GRID34=60
GRID35=70 ; GRID36=80 ; GRID37=85 ; GRID38=90 ; GRID39=95
GRID40=100 ; GRID41=110 ; GRID42=130 ; GRID43=150 ; GRID44=160
GRID45=170 ; GRID46=180 ; GRID47=190 ; GRID48=200 ; GRID49=200
GRID50=200 ; GRID51=200 ; GRID52=200 ; GRID53=200 ; GRID54=200

read_smart_temp() {
    HIGHEST_DRIVE_TEMP=$(ls /dev/ \
    | grep "^sd[a-z]$" \
    | xargs -I % /usr/builtin/sbin/smartctl -A "/dev/%" \
    | awk '/^194/ {print $10}' \
    | sort -n \
    | tail -1)
    echo "$HIGHEST_DRIVE_TEMP"
}

get_pwm_by_temp() {
    TEMP=$1
     eval 'PWM=$GRID'"$TEMP"
     echo "$PWM"
}

set_fan_pwm() {
    fanctrl -setfanpwm 0 "$1"
}

run_smart_fan_control() {
    INIT_TIME=$(date +%s.%N)
    echo "Starting smart fan control..."
    while :
    do
        CURRENT_TEMP=$(read_smart_temp)
        DESIRED_POWER=$(get_pwm_by_temp "$CURRENT_TEMP")
        CURRENT_POWER=$(fanctrl -getfanspeed|awk ' { print $NF } ' )
        if [ -n "$DESIRED_POWER" ] && [ "$DESIRED_POWER" -ne "$CURRENT_POWER" ]
        then
            echo "Setting fan from $CURRENT_POWER to $DESIRED_POWER PWM for $CURRENT_TEMP C as highest drives temp"
            set_fan_pwm "$DESIRED_POWER"
            TRIGGER_TIME=$(date +%s.%N)
            TIME_TO_SLEEP="$(echo "$TRIGGER_TIME-$INIT_TIME-1" | bc | grep "^[0-9]" )"
            INIT_TIME=$(date +%s.%N)
            if [ -n "$TIME_TO_SLEEP" ]
            then
              echo "Sleeping $TIME_TO_SLEEP s for new check..."
              sleep "$TIME_TO_SLEEP"
            fi
        fi
        sleep 0.1
    done
}

run_smart_fan_control &
