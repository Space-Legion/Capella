sudo pacman -S sway termite wofi waybar mpv alsa-utils pcmanfm-gtk3 swaylock gvfs file-roller eog arc-gtk-theme arc-icon-theme torbrowser-launcher xorg-xwayland ttf-jetbrains-mono ttf-nerd-fonts-symbols --needed --noconfirm

chmod +x .config/wofi/* 

cp -r .config /$HOME/

curl https://raw.githubusercontent.com/Space-Legion/assets/main/moon.jpg > /$HOME/.config/1.jpg

curl https://raw.githubusercontent.com/Space-Legion/assets/main/space-shuttle.jpg > /$HOME/.config/l.jpg

x=0
while [[ $x == 0 ]]

do
	clear
        echo "

         Do you wish to setup the firewall now? [y/n]
"
	read answer
	
	case "$answer" in 

 		y)
        chmod +x cloak-iptables && sudo ./cloak-iptables && cd && sway
        
		x=1
		;;

		n)
        cd && sway
        
		x=1
		;;

        *)
        printf "\nInvalid Option" & sleep 3 && exit 0

        ;;
		

	esac	
done


