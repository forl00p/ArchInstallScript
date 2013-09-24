# !/bin/bash

echo "----------------------------------"
echo "|    Arch Linux Installation     |"
echo "----------------------------------"

echo ""

echo "Welcome to the Arch Linux Installation Script. To begin the installation, please press enter when you are ready."

read

# Partitioning the Hard Drive
# To accomplish this, we will be using fdisk, and echoing the desired partition
# variables.

echo "Generating the partitions ..."

# /dev/sda1 - Boot Partition

echo "d"          >> fdisc.in   # Delete the other partitions
echo "n"          >> fdisc.in   # Create a new partition
echo "p"          >> fdisc.in   # Sets the partition as primary
echo ""           >> fdisc.in   # Leave partition number default
echo ""			  >> fdisc.in 	# Leave the partition beginning default
echo "+8G"     	  >> fdisc.in   # Set the partition size
echo "a"          >> fdisc.in   # Set the partition as bootable

# /dev/sda2 - Swap Partition

echo "n"          >> fdisc.in   # Create a new partition
echo "p"          >> fdisc.in   # Sets the partition as primary
echo ""           >> fdisc.in   # Leave partition number default
echo ""			  >> fdisc.in 	# Leave the partition beginning default
echo "+2048M"     >> fdisc.in   # Set the partition size
echo "t"          >> fdisc.in   # Set as swap
echo "2"          >> fdisc.in   # Set as swap
echo "82"         >> fdisc.in   # Set as swap

# /dev/sda3 - Root Partition

echo "n"          >> fdisc.in   # Create a new partition
echo "p"          >> fdisc.in   # Sets the partition as primary
echo ""           >> fdisc.in   # Leave partition number default
echo ""           >> fdisc.in   # The partition size is the rest of the HD
echo ""           >> fdisc.in   # Leave as default

# Creating the file system and installing the base system
# We will have the execute the fdisk file, clean up
# and mount the partitions to /dev/sda.

echo "Executing fdisk and creating the partitions ..."

fdisk /dev/sda < fdisc.in

echo "Cleaning up the partition file ..."

rm -f fdisc.in

echo "Applying a file system to the partitions ..."

mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2

echo "Activating the swap partition ..."

swapon /dev/sda2

echo "Mounting the partitions ..."

mount /dev/sda1 /mount
mkdir /mnt/home
mount /dev/sda3 /mnt/home

echo "Installing the base system ..."

pacstrap /mnt base base-devel

echo "Generating a fstab ..."

genfstab /mnt >> /mnt/etc/fstab

echo ""
echo "Please ensure that the fstab is OK!"
sleep 3

nano /mnt/etc/fstab

echo "Chrooting into the environment ..."

arch-chroot /mnt

# Setting the password, date / time,
# and the hostname.

echo "Setting a new root password ..."

passwd

echo "Setting the locale ..."

nano /etc/locale.gen

echo "Generating the locale ..."

locale-gen

echo "Setting a hostname for your device ..."

read HOSTNAME

echo {HOSTNAME} > /etc/hostname

# Installing GRUB as the bootloader

echo "Installing GRUB as the bootloader ..."

pacman -S grub-bios --noconfirm
grub-install /dev/sda
mkinitcpio -p linux

echo "Generating the GRUB configuration ..."

grub-mkconfig -o /boot/grub/grub.cfg

echo "Unmounting and cleaning up ..."

exit 
umount /mnt/home 
umount /mnt

echo ""
echo "BASE SYSTEM INSTALL IS NOW COMPLETE. RESTARTING IN 5 SECONDS."
echo "WHEN YOU ARE PROMPTED AT THE ARCH LINUX SETUP MENU, SELECT 'Boot Existing OS'"

sleep 5
reboot