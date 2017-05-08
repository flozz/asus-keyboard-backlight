#!/usr/bin/python
# -*- coding: UTF-8 -*-


"""Adds the keyboard backlight support for ASUS laptops."""

__version__ = "0.1"
__author__ = "Fabien Loison"
__copyright__ = "Copyright © 2010 Fabien LOISON"
__website__ = "https://github.com/flozz/asus-keyboard-backlight"


import os
import sys

#Export the display variable if not set
if not "DISPLAY" in os.environ:
    DISPLAY = False
    os.putenv("DISPLAY", ":0.0")
    #Hack to retrieve the X session cookie of the user.
    #Only works for those that uses GDM. May doesn't work if there is
    #more than one user cookie in the folder (gdm excluded).
    if os.path.isdir("/var/run/gdm/"):
        try:
            xcookie_dirs = os.listdir("/var/run/gdm/")
        except OSError:
            pass
        else:
            for xcookie_dir in xcookie_dirs:
                if xcookie_dir[:9] == "auth-for-" and xcookie_dir[9:12] != "gdm":
                    os.putenv(
                            "XAUTHORITY",
                            "/var/run/gdm/%s/database" % xcookie_dir,
                            )
                    DISPLAY = True
                    break
else:
    DISPLAY = True

if DISPLAY:
    try:
        import pynotify
        NOTIFY = True
    except ImportError:
        NOTIFY = False
else:
    NOTIFY = False


MAX_BRIGHTNESS_FILE = "/sys/devices/platform/asus_laptop/leds/asus::kbd_backlight/max_brightness"
BRIGHTNESS_FILE = "/sys/devices/platform/asus_laptop/leds/asus::kbd_backlight/brightness"
BRIGHTNESS_BAK_FILE = "/var/lib/asus-kbd-backlight/brightness"
BRIGHTNESS_BAK_DIR = "/var/lib/asus-kbd-backlight/"

MAX_BRIGHTNESS = 3
BRIGHTNESS = 1

BRIGHTNESS_ICONS = [
        "notification-keyboard-brightness-full",
        "notification-keyboard-brightness-high",
        "notification-keyboard-brightness-medium",
        "notification-keyboard-brightness-low",
        "notification-keyboard-brightness-off",
        ]


def get_max_brightness():
    """Get the max brightness"""
    global MAX_BRIGHTNESS
    if os.path.isfile(MAX_BRIGHTNESS_FILE):
        #Read file
        file_ = open(MAX_BRIGHTNESS_FILE, "r")
        max_brightness = file_.read()
        file_.close()
        #Extract info
        max_brightness = max_brightness.replace("\n", "")
        if max_brightness.isdigit():
            max_brightness = int(max_brightness)
            if max_brightness >= 128:
                max_brightness = max_brightness - 128
            MAX_BRIGHTNESS = max_brightness


def get_brightness():
    """Get the current brightness"""
    global BRIGHTNESS
    if os.path.isfile(BRIGHTNESS_FILE):
        #Read file
        file_ = open(BRIGHTNESS_FILE, "r")
        brightness = file_.read()
        file_.close()
        #Extract info
        brightness = brightness.replace("\n", "")
        if brightness.isdigit():
            brightness = int(brightness)
            if brightness >= 0 and brightness <= MAX_BRIGHTNESS:
                BRIGHTNESS = brightness
            elif brightness >= 128 and brightness <= MAX_BRIGHTNESS + 128:
                BRIGHTNESS = brightness - 128


def set_brightness(value):
    """Set the brightness to <value>

    Argument:
        * value -- an integer number between 0 and MAX_BRIGHTNESS
    """
    #Set the brightness
    if os.path.isfile(BRIGHTNESS_FILE):
        try:
            file_ = open(BRIGHTNESS_FILE, "w")
            file_.write(str(value))
        except IOError:
            pass
        else:
            file_.close()
    #Save the bak file
    if not os.path.isdir(BRIGHTNESS_BAK_DIR):
        try:
            os.makedirs(BRIGHTNESS_BAK_DIR)
        except OSError:
            pass
    try:
        file_ = open(BRIGHTNESS_BAK_FILE, "w")
        file_.write(str(value))
    except IOError:
        pass
    else:
        file_.close()


def notify():
    """Display an OSD"""
    #Set the icon
    icon_index = int((MAX_BRIGHTNESS - BRIGHTNESS) * (len(BRIGHTNESS_ICONS) - 1) / MAX_BRIGHTNESS)
    #Calculate the %
    value = BRIGHTNESS * 100 / MAX_BRIGHTNESS
    #Notify
    notification = pynotify.Notification(
            "Brightness",
            "",
            BRIGHTNESS_ICONS[icon_index],
            )
    notification.set_hint_int32("value", value)
    notification.set_hint_string("x-canonical-private-synchronous", "")
    notification.show()


if len(sys.argv) == 2 and sys.argv[1] in ("up", "down"):
    #Get informations
    get_max_brightness()
    get_brightness()
    #Calculate the new brightness
    if sys.argv[1] == "up":
        BRIGHTNESS += 1
        if BRIGHTNESS > MAX_BRIGHTNESS:
            BRIGHTNESS = MAX_BRIGHTNESS
    else:
        BRIGHTNESS -= 1
        if BRIGHTNESS < 0:
            BRIGHTNESS = 0
    #Set the new_brightness
    set_brightness(BRIGHTNESS)
    #Notify
    if NOTIFY:
        notify()


