#!/usr/bin/env bash
# name=custom/generic-amd64/after-install.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh;
# log name of script
_fn_logger 'generic-amd64/after-install.sh';
### INCLUDE ###

fn_core_swapfile () {
    ${var_install_tmp_path}/${_var_core_swapfile_script_name};
    _fn_logger 'run core-swapfile.sh';
}

#fn_core_dhcpclient () {
#    ${var_install_tmp_path}/${_var_core_dhcpclient_script_name};
#    _fn_logger 'run core-dhcpclient.sh';
#}

fn_core_btrfs () {
    ${var_install_tmp_path}/${_var_core_btrfs_script_name};
    _fn_logger 'run core-btrfs.sh';
}

# create swapfile
fn_core_swapfile;

# replace dhcp client
fn_core_dhcpclient;

# create btrfs subvolumes last
fn_core_btrfs;
