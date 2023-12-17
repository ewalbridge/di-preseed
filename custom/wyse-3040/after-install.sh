#!/usr/bin/env bash
# name=custom/wyse-3040/after-install.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh;
# log name of script
_fn_logger 'wyse-3040/after-install.sh';
### INCLUDE ###

### ADDITIONAL APT PACKAGES ###
var_apt_install_packages='openssh-server avahi-daemon libnss-mdns augeas-tools tcpdump firmware-intel-sound wpasupplicant wi wireless-tools';
### ADDITIONAL APT PACKAGES ###

var_core_swapfile_script_name='core-swapfile.sh';
var_core_dhcpclient_script_name='core-dhcpclient.sh';
var_core_btrfs_script_name='core-btrfs.sh';

fn_download_files () {
    # download core-swapfile.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${var_core_swapfile_script_name};
    chmod +x ${var_install_tmp_path}/${var_core_swapfile_script_name};

    # download core-dhcpclient.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${var_core_dhcpclient_script_name};
    chmod +x ${var_install_tmp_path}/${var_core_dhcpclient_script_name};

    # download core-btrfs.sh and set as executable 
    _fn_download_file ${_var_shared_url_path} ${var_install_tmp_path} ${var_core_btrfs_script_name};
    chmod +x ${var_install_tmp_path}/${var_core_btrfs_script_name};
}

fn_install_custom (){
    # instead of preseed.cfg: d-i pkgsel/include
    # offers greater control
    apt install -y ${var_apt_install_packages}
}

fn_core_swapfile () {
    ${var_install_tmp_path}/${var_core_swapfile_script_name};
    _fn_logger 'run core-swapfile.sh';
}

fn_core_dhcpclient () {
    ${var_install_tmp_path}/${var_core_dhcpclient_script_name};
    _fn_logger 'run core-dhcpclient.sh';
}

fn_core_btrfs () {
    ${var_install_tmp_path}/${var_core_btrfs_script_name};
    _fn_logger 'run core-btrfs.sh';
}


# download all installer related files first
fn_download_files;

# install custom packages second
fn_install_custom;

# create swapfile
fn_core_swapfile;

# replace dhcp client
fn_core_dhcpclient;

# create btrfs subvolumes last
fn_core_btrfs;