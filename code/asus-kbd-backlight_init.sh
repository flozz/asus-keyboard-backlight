#!/bin/bash


BRIGHTNESS_FILE="/sys/devices/platform/asus_laptop/leds/asus::kbd_backlight/brightness"
BRIGHTNESS_BAK_FILE="/var/lib/asus-kbd-backlight/brightness"
DEFAULT=1


if [ -f "$BRIGHTNESS_BAK_FILE" ] ; then {
	#Restores the last value
	cat "$BRIGHTNESS_BAK_FILE" > "$BRIGHTNESS_FILE"
} else {
	#Sets the default value
	echo "$DEFAULT" > "$BRIGHTNESS_FILE"
} fi


exit 0

