#!/bin/bash

printf 'Max brighntness is:\n'
cat /sys/class/backlight/intel_backlight/max_brightness
printf 'sudo vim into this file and set:\n/sys/class/backlight/intel_backlight/brightness\n'
