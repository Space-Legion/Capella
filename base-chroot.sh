#!/bin/bash


ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime


echo en_US.UTF-8 UTF-8 >> /etc/locale.gen 


echo en_US ISO-8859-1 >> /etc/locale.gen 


locale-gen 


echo LANG=en_US.UTF-8 >> /etc/locale.conf 


echo host >> /etc/hostname 

root_pass () {

passwd 

[[ $? != 0 ]] && root_pass

}

printf "Enter the password for root:\n" && root_pass


pacman -Sy grub efibootmgr networkmanager --needed --noconfirm 


sed -i 's/base udev autodetect modconf block filesystems keyboard fsck/base udev autodetect modconf block encrypt filesystems keyboard fsck/g' /etc/mkinitcpio.conf


#vim /etc/mkinitcpio.conf


mkinitcpio -p linux-lts
    

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB 


grub-mkconfig -o /boot/grub/grub.cfg 


luks_bid=$(blkid | grep "crypto_LUKS" | grep -o -P '(?<=UUID=").*(?="\sTYPE)')


grublno=$(grep -Fn 'GRUB_CMDLINE_LINUX=' /etc/default/grub | cut -f1 -d":")


sed -i -e "${grublno}d" /etc/default/grub


varg="cryptdevice=UUID=${luks_bid}:cryptroot root=/dev/mapper/cryptroot"


varq=$(echo $varg | sed 's/^/"/;s/$/"/')


sed -i "${grublno}i GRUB_CMDLINE_LINUX=${varq}"  /etc/default/grub


grub-mkconfig -o /boot/grub/grub.cfg 


systemctl enable NetworkManager 


useradd -mG wheel user


user_pass () {


passwd user


[[ $? != 0 ]] && user_pass


}


printf "Enter password for user:\n" && user_pass



echo "root ALL=(ALL) ALL 
%wheel ALL=(ALL) ALL 
@includedir /etc/sudoers.d" > /etc/sudoers


echo -e "printf '
The base installation has been completed

Before proceeding, make sure you are connected to the internet

To continue the post installation clone the main repo

ie, git clone https://github.com/Space-Legion/Capella and run sway.sh

'" >> /home/user/.bashrc


echo "rm .bashrc" >> /home/user/.bashrc


exit
