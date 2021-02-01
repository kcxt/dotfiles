#!/bin/bash

# This script is meant to be symlinked to /usr/lib/systemd/system-sleep/
# https://blog.christophersmart.com/2016/05/11/running-scripts-before-and-after-suspend-with-systemd/comment-page-1/
# It will enable the keyboard backlight on leaving suspend
# We don't need to bother disabling it, ever, because firmware does that for us

## Change this to match your vendor
BRIGHTNESS_FILE="/sys/class/leds/tpacpi::kbd_backlight/brightness"
BRIGHTNESS_STORE="/tmp/kb_brightness"
DEFAULT_BRIGHTNESS="2"

if [ "${1}" == "pre" ]; then
	echo "$0: Dumping current kbd backlight value to $BRIGHTNESS_STORE"
	cat $BRIGHTNESS_FILE > $BRIGHTNESS_STORE
elif [ "${1}" == "post" ]; then
	echo "$0: Reading backlight brightness as we're exiting suspend"
	BRIGHTNESS=$(cat $BRIGHTNESS_STORE)
	case $BRIGHTNESS in
		[0-2])
			;;
		*)
			echo "Invalid value: '$BRIGHTNESS', defaulting to $DEFAULT_BRIGHTNESS"
			BRIGHTNESS=$DEFAULT_BRIGHTNESS
			;;
	esac
	echo "$0: Setting kbd backlight brightness to '$BRIGHTNESS'"
	echo $BRIGHTNESS > $BRIGHTNESS_FILE
fi;
