timedatectl set-ntp true

read -p "Drive Encryption password : " ENCRPYTION_PASS

read -p "Drive Name (eg: /dev/sda) : " DRIVE

cfdisk $DRIVE

lsblk $DRIVE && read -p "EFI partition : " DISK_EFI

read -p "root partition : " DISK_ROOT

mkfs.fat -F32 /dev/$DISK_EFI

echo -n "$ENCRPYTION_PASS" | cryptsetup -y -v luksFormat /dev/$DISK_ROOT

echo -n "$ENCRPYTION_PASS" | cryptsetup open /dev/$DISK_ROOT cryptroot

mkfs.ext4 /dev/mapper/cryptroot

mount /dev/mapper/cryptroot /mnt

mkdir /mnt/boot

mount /dev/$DISK_EFI /mnt/boot

pacstrap /mnt base sudo linux-lts linux-firmware vim git

genfstab -U /mnt >> /mnt/etc/fstab 

cp base-chroot.sh /mnt/base-chroot.sh 

chmod +x /mnt/base-chroot.sh 

arch-chroot /mnt bash base-chroot.sh && rm /mnt/base-chroot.sh 

umount -R /mnt

reboot




