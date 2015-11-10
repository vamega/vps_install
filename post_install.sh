#!/bin/bash

set -euo pipefail

function set_up_services()
{
    systemctl enable nginx.service
}

function set_up_reflector()
{
    cp data/reflector.service /etc/systemd/system/reflector.service
    cp data/reflector.timer /etc/systemd/system/reflector.timer

    systemctl enable reflector.timer
}

function set_up_language()
{
    sed -i 's/^#\(en_US.UTF-8\)/\1/' /etc/locale.gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    export LANG=en_US.UTF-8
    locale-gen
}

function set_up_time()
{
    ln -sf /usr/share/zoneinfo/$TIME_ZOME /etc/localtime
    hwclock --systohc --utc
}

function set_up_networking()
{
    echo $HOSTNAME > /etc/hostname
    cp data/hosts /etc/hosts
    cp data/ethernet.network /etc/systemd/network/ethernet.network
    systemctl enable systemd-networkd.service
}

function install_aura()
{
    mkdir -p /home/me/builds
    wget -P /home/me/builds/ https://aur.archlinux.org/cgit/aur.git/snapshot/aura-bin.tar.gz
    pushd /home/me/builds
    tar -xvf aura-bin.tar.gz
    cd aura-bin
    chown -R me:me /home/me/builds
    sudo -u me makepkg
    pacman-db-upgrade
    pacman -U --noconfirm aura-bin*pkg.tar.xz
    popd
}

function set_up_ssh()
{
    cp data/sshd_config /etc/ssh/sshd_config
    mkdir -p /home/me/.ssh/
    cp data/id_ecdsa.pub /home/me/.ssh/
    
    systemctl enable openssh.service
}

function set_up_user()
{
    useradd -m me
    chmod 740 /etc/sudoers
    cp data/sudoers /etc/sudoers
    chmod 440 /etc/sudoers
    mkdir -p /home/me/.ssh
    cp data/id_ecdsa.pub /home/me/.ssh/authorized_keys
    chown -R me:me /home/me/
}

function set_up_bootloader()
{
    syslinux-install_update -i -m
    dd bs=440 conv=notrunc count=1 if=usr/lib/syslinux/bios/gptmbr.bin of=/dev/vda
    cp data/syslinux.cfg /boot/syslinux/syslinux.cfg
}

function generate_mkinitcpio()
{
    cp data/mkinitcpio.conf /etc/mkinitcpio.conf
    mkinitcpio -p linux
}

cd "$(dirname "$0")"
source variables.sh

set_up_language
set_up_time
set_up_user
set_up_reflector
set_up_services
set_up_networking
install_aura
generate_mkinitcpio
set_up_bootloader
passwd
