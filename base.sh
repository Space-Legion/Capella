#!/bin/bash


enc_pass() {
	echo "Drive Encryption password :"
	read  ENCRPYTION_PASS0
	echo "Confirm Drive Encryption password :"
	read  ENCRPYTION_PASS1 
	[[ "$ENCRPYTION_PASS0" !=  "$ENCRPYTION_PASS1" ]] && enc_pass
}


enc_pass 


lsblk


read -p "Drive Name (eg: /dev/sda) : " DRIVE


cat <<EOF | parted -a optimal $DRIVE
mklabel GPT
mkpart ESP fat32 0% 250M
mkpart primary ext4 250M 100%
EOF


lsblk $DRIVE && read -p "EFI partition : " DISK_EFI


read -p "root partition : " DISK_ROOT


echo -n "$ENCRPYTION_PASS1" | cryptsetup -y -v luksFormat /dev/$DISK_ROOT


echo -n "$ENCRPYTION_PASS1" | cryptsetup open /dev/$DISK_ROOT cryptroot


mkfs.ext4 /dev/mapper/cryptroot


mount /dev/mapper/cryptroot /mnt


mkfs.fat -F32 /dev/$DISK_EFI


mkdir /mnt/boot


mount /dev/$DISK_EFI /mnt/boot


pacstrap /mnt base sudo linux-lts linux-firmware vim git


genfstab -U /mnt >> /mnt/etc/fstab 


cp base-chroot.sh /mnt/base-chroot.sh 


cp -r .config post-install.sh /mnt/


chmod +x /mnt/base-chroot.sh 


arch-chroot /mnt bash base-chroot.sh && rm /mnt/base-chroot.sh 


umount -R /mnt


reboot



