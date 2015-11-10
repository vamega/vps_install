#!/bin/bash

set -euo pipefail

function create_mirrorlist()
{
    local MIRROR_LIST_URL="https://www.archlinux.org/mirrorlist/?country=CA&country=US&protocol=http&ip_version=4"
    wget $MIRROR_LIST_URL -O /tmp/new_mirrorlist

    if [ $? -ne 0 ]; then
        echo "Unable to download mirrorlist"
        echo "Mirrorlist not updated. Downloading packages might be slow."
    else
        cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
        mv /tmp/new_mirrorlist /etc/pacman.d/mirrorlist.new
        
        sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.new
        rankmirrors -n 6 /etc/pacman.d/mirrorlist.new > /etc/pacman.d/mirrorlist
    fi
}


function partition_and_format()
{
    sgdisk -Z /dev/vda
    parted --script /dev/vda mklabel msdos
    parted --script /dev/vda mkpart primary linux-swap 1MiB 2GiB
    parted --script /dev/vda mkpart primary btrfs 2GiB 100%
    parted --script /dev/vda set 2 boot on

    mkswap /dev/vda1
    swapon /dev/vda1

    mkfs.btrfs -f -L "Root" /dev/vda2
}

function mount_devices()
{
    mount /dev/vda2 /mnt
}

function finish()
{
    swapoff -a
    umount /mnt/
}

function set_up_resolv_conf()
{
    rm /mnt/etc/resolv.conf
    chroot /mnt ln -sfv /run/systemd/resolve/resolv.conf /etc/resolv.conf
}

trap finish EXIT

cd "$(dirname "$0")"
source variables.sh

partition_and_format
create_mirrorlist
mount_devices
pacstrap /mnt base base-devel ${PACKAGES[@]}
genfstab -U -p /mnt >> /mnt/etc/fstab
cp -r . /mnt/root
arch-chroot /mnt /root/post_install.sh
set_up_resolv_conf



echo "Finished Installing system."
echo "Unmount ISO, then hit any key to continue."
read ANSWER
reboot
