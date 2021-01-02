ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

hwclock --systohc 

echo en_US.UTF-8 UTF-8 >> /etc/locale.gen 

echo en_US ISO-8859-1 >> /etc/locale.gen 

locale-gen 

echo LANG=en_US.UTF-8 >> /etc/locale.conf 

echo host >> /etc/hostname 

passwd 

pacman -S grub efibootmgr networkmanager --needed --noconfirm 

sed -i 's/base udev autodetect modconf block filesystems keyboard fsck/base udev autodetect modconf block encrypt filesystems keyboard fsck/g' /etc/mkinitcpio.conf

mkinitcpio -p linux
    
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB 

grub-mkconfig -o /boot/grub/grub.cfg 

luks_bid=$(blkid | grep "crypto LUKS" | grep -o -P '(?<=UUID=").*(?=" LABEL)')

sed -i 's/GRUB_CMDLINE_LINUX=/GRUB_CMDLINE_LINUX=cryptdevice=UUID=$luks_bid:cryptroot/g' /boot/grub/grub.cfg

grub-mkconfig -o /boot/grub/grub.cfg 

systemctl enable NetworkManager 

useradd -mG wheel user

passwd user 

echo "root ALL=(ALL) ALL 
%wheel ALL=(ALL) ALL 
@includedir /etc/sudoers.d" > /etc/sudoers

exit
