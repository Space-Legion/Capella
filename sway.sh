#!/bin/bash

base() {
sudo pacman -S sway termite wofi waybar mpv alsa-utils pcmanfm-gtk3 swaylock gvfs file-roller eog arc-gtk-theme arc-icon-theme torbrowser-launcher xorg-xwayland ttf-jetbrains-mono ttf-nerd-fonts-symbols --needed --noconfirm

chmod +x .config/wofi/* 

cp -r .config /$HOME/

curl https://raw.githubusercontent.com/Space-Legion/assets/main/moon.jpg > /$HOME/.config/1.jpg

curl https://raw.githubusercontent.com/Space-Legion/assets/main/space-shuttle.jpg > /$HOME/.config/l.jpg

}


firewall() { 
clear
read -n 1 -p "

 Do you wish to setup the firewall now? [y/n] 

" ans;
case $ans in

    Y|y)

    chmod +x cloak-iptables && sudo ./cloak-iptables && cd && sway;;


    n|N)
       cd && sway;;

    *)
     firewall 

esac
}


#functions call 
base
firewall
