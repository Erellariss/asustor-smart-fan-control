# asustor-smart-fan-control

This script allows you to automatically manage your Asustor fan's PWM based on the hottesst drive temperature (taken from S.M.A.R.T.).
You can adjust GRID variables for your needs.

Tested on AS5202T (ADM 4.2.5.RN33).

Run from terminal (you have to be superuser to run that):
```bash
./smart_fan_control.sh
```

If you have more than one fan in your device, you can adjust set_fan_pwm function:
```bash
set_fan_pwm() {
    fanctrl -setfanpwm 0 "$1"
    fanctrl -setfanpwm 1 "$1"
    ...
}
```

For startup configuration, put this script according to https://forum.asustor.com/viewtopic.php?f=49&t=1681

This script was inspired by https://forum.asustor.com/viewtopic.php?f=23&t=11013
