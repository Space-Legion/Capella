#!/bin/bash


enc_pass() {
	echo "Drive Encryption password :"
	read  ENCRPYTION_PASS0
	echo "Confirm Drive Encryption password :"
	read  ENCRPYTION_PASS1 
	[[ "$ENCRPYTION_PASS0" !=  "$ENCRPYTION_PASS1" ]] && enc_pass
}


enc_pass 


single_disk () {
DISK="$(lsblk --list | grep 'disk' | awk '{print $1}')"
    while true; do
		read -p "$* >install on $DISK [y/n]: " yn
		case $yn in
			   [Yy]*) disk_partition ;;
			   [Nn]*) multi_disk ;;
		esac
		done
}

manual_disk() {

lsblk && read -p "Drive Name (eg: sda or nvme) : " DISK

disk_partition

}



multi_disk() {

prompt="Please select the disk to install:"
options=( $(lsblk --list | grep 'disk' | awk '{ print $1}') )

PS3="$prompt "
select opt in "${options[@]}" "Enter manually" ; do
	    if (( REPLY == 1 + ${#options[@]} )) ; then
			manual_disk
		    elif (( REPLY > 0 && REPLY <= ${#options[@]} )) ; then
	        DISK="$opt"
			echo  "installing on $opt"; disk_partition
    	    break
	    else
        	echo "Invalid option. Try again."
	    fi
done

disk_partition

}

disk_partition() {


wipefs -a -f /dev/$DISK
cat <<EOF | parted -a optimal /dev/$DISK
mklabel GPT
mkpart ESP fat32 0% 250M
mkpart primary ext4 250M 100%
EOF

mount_disk

}

mount_disk() {


DISK_EFI="$(lsblk --list -o +PARTLABEL /dev/$DISK | grep 'ESP' | awk '{ print $1 }')"

DISK_ROOT="$(lsblk --list -o +PARTLABEL /dev/$DISK | grep 'primary' | awk '{ print $1 }')"


echo -n "$ENCRPYTION_PASS1" | cryptsetup -y -v luksFormat /dev/$DISK_ROOT


echo -n "$ENCRPYTION_PASS1" | cryptsetup open /dev/$DISK_ROOT cryptroot


mkfs.ext4 /dev/mapper/cryptroot


mount /dev/mapper/cryptroot /mnt


mkfs.fat -F32 /dev/$DISK_EFI


mkdir /mnt/boot


mount /dev/$DISK_EFI /mnt/boot

base_pacstrap

}

base_pacstrap() {

pacstrap /mnt base sudo linux-lts linux-firmware vim git


genfstab -U /mnt >> /mnt/etc/fstab 


cp base-chroot.sh /mnt/base-chroot.sh 


chmod +x /mnt/base-chroot.sh 


arch-chroot /mnt bash base-chroot.sh && rm /mnt/base-chroot.sh 


umount -R /mnt


reboot

}


[[ $(lsblk | grep 'disk' | wc -l) ]] && single_disk "$@" || multi_disk "$@" 
