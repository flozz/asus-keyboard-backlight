#!/bin/bash
### BEGIN INIT INFO
# Provides: asus-kbd-backlight
# Required-Start:    $local_fs $syslog $remote_fs acpid
# Required-Stop:     $local_fs $syslog $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Sets the brighness of the keyboard on ASUS laptops
### END INIT INFO


BRIGHTNESS_FILE="/sys/devices/platform/asus_laptop/leds/asus::kbd_backlight/brightness"
BRIGHTNESS_BAK_FILE="/var/lib/asus-kbd-backlight/brightness"
DEFAULT=1

case $1 in
	start)
		if [ -f "$BRIGHTNESS_BAK_FILE" ] ; then {
			#Restores the last value
			cat "$BRIGHTNESS_BAK_FILE" > "$BRIGHTNESS_FILE"
			echo "ASUS Keyboard Backlight: Restores the last brightness..."
		} else {
			#Sets the default value
			echo "$DEFAULT" > "$BRIGHTNESS_FILE"
			echo "ASUS Keyboard Backlight: Sets the default brightness..."
		} fi
		;;
	stop|force-reload|restart)
		exit 0
		;;
esac


exit 0

