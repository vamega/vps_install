#!/bin/bash

source variables.sh

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
    sgdisk -n 0:0:+2G -t 0:8200 -c 0:"Swap" /dev/vda
    sgdisk -n 0:0:0 -t 0:8300 -c 0:"Root" /dev/vda

    mkswap /dev/vda1
    swapon /dev/vda1

    mkfs.btrfs -L "Root" /dev/vda2
}

partition_and_format
create_mirrorlist
pacstrap /mnt base base-devel ${PACKAGES[@]}
genfstab -U -p /mnt >> /mnt/etc/fstab

