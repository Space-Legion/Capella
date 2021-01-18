sudo pacman -S sway termite wofi waybar mpv alsa-utils pcmanfm-gtk3 swaylock gvfs file-roller eog arc-gtk-theme arc-icon-theme torbrowser-launcher xorg-xwayland ttf-jetbrains-mono ttf-nerd-fonts-symbols --needed --noconfirm

chmod +x .config/wofi/* 

cp -r .config /$HOME/

curl https://raw.githubusercontent.com/Space-Legion/assets/main/moon.jpg > /$HOME/.config/1.jpg

curl https://raw.githubusercontent.com/Space-Legion/assets/main/space-shuttle.jpg > /$HOME/.config/l.jpg

cd && sway

