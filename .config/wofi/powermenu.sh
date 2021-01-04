#!/usr/bin/sh


wofi_command="wofi -theme /$HOME/.config/rofi/powermenu -width 20 -dmenu -i -p wofi-power:"

# Options
shutdown=" Shutdown"
reboot="勒 Reboot"
lock=" Lock"
logout=" Logout"

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$logout"

chosen=`echo -e $options | $wofi_command` # | awk '{print $1}' | tr -d '\r\n'`
case $chosen in
    $shutdown)
        poweroff
	;;
    $reboot)
        reboot
	;;
    $lock)
        i3lock -c 2e3440
	;;
    $logout)
        pkill -KILL -u $USER
	;;
esac

