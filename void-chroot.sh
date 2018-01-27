#!/bin/bash

cryptsetup -v open /dev/mapper/evo-root root
mount -v /dev/mapper/root /mnt
mount -v /dev/sda2 /mnt/boot
mount -v /dev/sda1 /mnt/boot/efi
mount -v -t proc /proc /mnt/proc
mount -v --rbind /sys /mnt/sys
mount -v --rbind /dev /mnt/dev
chroot /mnt /bin/bash
