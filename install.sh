#!/bin/bash

#Installation script for ASUS Keyboard Backlight

_install() {
	#Install
	#$1 : the output path, if different of /
	#ACPI events
	mkdir -pv "$1"/etc/acpi/events/
	cp -v ./events/* "$1"/etc/acpi/events/
	#ACPI script
	cp -v ./code/asus-kbd-backlight.py "$1"/etc/acpi/
	chmod 755 "$1"/etc/acpi/asus-kbd-backlight.py
	#Resume script
	mkdir -pv "$1"/etc/pm/sleep.d/
	cp -v ./code/asus-kbd-backlight_resume.sh "$1"/etc/pm/sleep.d/80_asus-kbd-backlight
	chmod 755 "$1"/etc/pm/sleep.d/80_asus-kbd-backlight
	#Init script
	mkdir -pv "$1"/etc/init.d/
	cp -v ./code/asus-kbd-backlight_init.sh  "$1"/etc/init.d/asus-kbd-backlight
	chmod 755 "$1"/etc/init.d/asus-kbd-backlight
	if [ "$1" == "" ] ; then { #Only for install
		ln -v --symbolic /etc/init.d/asus-kbd-backlight /etc/rc2.d/S80asus-kbd-backlight
		/etc/init.d/acpid restart
	} fi
	#Doc
	mkdir -pv "$1"/usr/share/doc/asus-kbd-backlight/
	cp -v ./README "$1"/usr/share/doc/asus-kbd-backlight/
	cp -v ./AUTHORS "$1"/usr/share/doc/asus-kbd-backlight/
}


_remove() {
	rm -rv /usr/share/doc/asus-kbd-backlight/
	rm -v /etc/acpi/events/asus-kb-brightness-down
	rm -v /etc/acpi/events/asus-kb-brightness-up
	rm -v /etc/acpi/asus-kbd-backlight.py
	rm -v /etc/pm/sleep.d/80_asus-kbd-backlight
	rm -v /etc/init.d/asus-kbd-backlight
	test -f /etc/rc2.d/S80asus-kbd-backlight \
		&& rm -v /etc/rc2.d/S80asus-kbd-backlight
	/etc/init.d/acpid restart
}


#Force english
export LANG=c
#Go to the scrip directory
cd "${0%/*}" 1> /dev/null 2> /dev/null

#Head text
echo "ASUS Keyboard Backlight - keyboard backlight support for ASUS laptops."
echo

#Action do to
if [ "$1" == "--install" ] || [ "$1" == "-i" ] ; then {
	echo "Installing ASUS Keyboard Backlight..."
	if [ "$(whoami)" == "root" ] ; then {
		_install
	} else {
		echo "E: Need to be root"
		exit 1
	} fi
} elif [ "$1" == "--package" ] || [ "$1" == "-p" ] ; then {
	echo "Packaging ASUS Keyboard Backlight..."
	if [ -d "$2" ] ; then {
		_install "$2"
	} else {
		echo "E: '$2' is not a directory"
		exit 2
	} fi
} elif [ "$1" == "--remove" ] || [ "$1" == "-r" ] ; then {
	echo "Removing ASUS Keyboard Backlight..."
	if [ "$(whoami)" == "root" ] ; then {
		_remove
	} else {
		echo "E: Need to be root"
		exit 1
	} fi
} else {
	echo "Arguments :"
	echo "  --install : install ASUS Keyboard Backlight on your computer."
	echo "  --package <path> : install ASUS Keyboard Backlight in <path> (Useful for packaging)."
	echo "  --remove : remove ASUS Keyboard Backlight from your computer."
} fi

exit 0


