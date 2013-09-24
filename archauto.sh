# !/bin/bash

echo "
   _____                .__      .____    .__                      .___                 __         .__  .__   
  /  _  \_______   ____ |  |__   |    |   |__| ____  __ _____  ___ |   | ____   _______/  |______  |  | |  |  
 /  /_\  \_  __ \_/ ___\|  |  \  |    |   |  |/    \|  |  \  \/  / |   |/    \ /  ___/\   __\__  \ |  | |  |  
/    |    \  | \/\  \___|   Y  \ |    |___|  |   |  \  |  />    <  |   |   |    ___ \  |  |  / __ \|  |_|  |__
\____|__  /__|    \___  >___|  / |_______ \__|___|  /____//__/\_ \ |___|___|  /____  > |__| (____  /____/____/
        \/            \/     \/          \/       \/            \/          \/     \/            \/           "

echo ""

echo "Welcome to the Arch Linux Installation Script. To begin the installation, please press enter when you are ready."

read

echo ""
echo "Starting the script ..."
echo ""

echo -e "\e[91mApplying a file system to the partitions ..."
echo ""

echo "Applying a file system to /dev/sda1 ..."
echo ""

mkfs.ext4 /dev/sda1

echo ""
echo "Applying a file system to /dev/sda3 ..."
echo ""

mkfs.ext4 /dev/sda3

echo ""
echo "Creating the swap partition ..."
echo ""

mkswap /dev/sda2

echo ""
echo "Activating the swap partition ..."
echo ""

swapon /dev/sda2

echo ""
echo "Mounting the partitions ..."
echo ""

mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home

echo "Installing the base system ..."

pacstrap /mnt base base-devel

echo "Generating a fstab ..."

genfstab /mnt >> /mnt/etc/fstab

echo ""
echo "Please ensure that the fstab is OK!"
sleep 10

nano /mnt/etc/fstab

echo "Chrooting into the environment ..."

arch-chroot /mnt

# Setting the password, date / time,
# and the hostname.

echo "Setting a new root password ..."

sleep 10

passwd

echo "Setting the locale ..."

sleep 5

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
