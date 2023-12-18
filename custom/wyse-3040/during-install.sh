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

### ADDITIONAL APT PACKAGES ###
var_apt_install_packages='openssh-server avahi-daemon libnss-mdns augeas-tools tcpdump firmware-intel-sound'; # wpasupplicant wireless-tools
### ADDITIONAL APT PACKAGES ###

fn_install_custom () {
    # instead of preseed.cfg: d-i pkgsel/include
    # offers greater control
    # cat '/root/tmp/apt.list' | xargs | apt-get install -y;
    apt-get install -y ${var_apt_install_packages};
}

fn_download_files () {
    # download core-swapfile.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${_var_core_swapfile_script_name};
    chmod +x ${var_install_tmp_path}/${_var_core_swapfile_script_name};

    # download core-dhcpclient.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${_var_core_dhcpclient_script_name};
    chmod +x ${var_install_tmp_path}/${_var_core_dhcpclient_script_name};

    # download core-btrfs.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${_var_core_btrfs_script_name};
    chmod +x ${var_install_tmp_path}/${_var_core_btrfs_script_name};
}

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

# install custom packages
fn_install_custom;

# download all installer related files
fn_download_files;

# create BOOTX64.EFI stub
fn_create_efi_stub;
