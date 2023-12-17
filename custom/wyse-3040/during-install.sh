#!/usr/bin/env bash
# name=custom/wyse-3040/during-install.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh;
# log name of script
_fn_logger 'wyse-3040/during-install.sh';
### INCLUDE ###

# wyse 3040 needs /EFI/BOOT/BOOTX64.EFI
# https://wiki.debian.org/InstallingDebianOn/Dell/Wyse%203040
fn_create_efi_stub () {

    local efi_device_path="/dev/mmcblk0p1";
    local efi_mount_path="/mnt";
    local efi_boot_path="/EFI/BOOT";

    # mount btrfs root
    mount ${efi_device_path} ${efi_mount_path};

    # create EFI BOOT directory
    mkdir ${efi_mount_path}${efi_boot_path};

    # create empty BOOTX64.EFI file
    touch ${efi_mount_path}${efi_boot_path}/BOOTX64.EFI;

    # unmount btrfs root
    umount ${efi_mount_path};
}

fn_create_efi_stub;
