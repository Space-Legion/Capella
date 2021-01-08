#!/usr/bin/bash

#chosen="$(echo -e 'Shutdown\nReboot\nLock\nSuspend\nHibernate\nLogout' | wofi -d -L 6 -W 200 -H 200 -p 'Powermenu')"
chosen="$(echo -e 'Shutdown\nReboot\nLock\nLogout' | wofi -d -L 5 -W 200 -H 200 -p 'Powermenu')"
case $chosen in
    Shutdown)systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Lock) swaylock -c 550000 ;;
    #Suspend) systemctl suspend ;;
    #Hibernate) systemctl hibernate ;;
    Logout) swaymsg exit ;;
esac
exit
