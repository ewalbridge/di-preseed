#!/usr/bin/env bash
# name=custom/generic-amd64/during-install.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh;
# log name of script
_fn_logger 'generic-amd64/during-install.sh';
### INCLUDE ###

### ADDITIONAL APT PACKAGES ###
var_apt_install_packages='openssh-server'; #dhcpcd5
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

# install custom packages
fn_install_custom;

# download all installer related files
fn_download_files;
