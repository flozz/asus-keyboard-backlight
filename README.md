# ASUS Keyboard Backlight

> Configure the keyboard backlight on ASUS laptops.

__NOTE:__ This is the new repository of ASUS Keyboard Backlight that used to be hosted on Launchpad: https://launchpad.net/asus-keyboard-backlight


## Dependencies

    * Python
    * ACPI Daemon
    * ~~(optional) pyNotify~~ this is not required anymore as the code that
      uses this works with an old Xorg and GDM


## Installing ASUS Keyboard Backlight

Run the following command as root from the project root directory:

    ./install.sh --install


## Uninstalling ASUS Keyboard Backlight

Run the following command as root from the project root directory:

    ./install.sh --remove


## Changelog

* **2017-05-08:**
    * Project imported to Github
    * README rewrote
    * License changed from GPLv3+ to WTFPL
