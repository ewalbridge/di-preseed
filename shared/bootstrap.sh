#!/usr/bin/env bash
# name=shared/bootstrap.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh
# log name of script
_fn_logger 'shared/bootstrap.sh';
### INCLUDE ###


# preseed identifier
var_custom_preseed_id=${1};

# download and start custom install functions
# this is called from preseed.cfg d-i preseed/late_command
fn_bootstrap () {
    # download during-install.sh and set as executable 
    _fn_download_file ${_var_custom_url_path}/${var_custom_preseed_id} ${var_install_tmp_path} ${_var_during_install_script_name};
    chmod +x ${var_install_tmp_path}/${_var_during_install_script_name};
    # run during-install.sh
    ${var_install_tmp_path}/${_var_during_install_script_name};

    # download after-install.sh and set as executable 
    _fn_download_file ${_var_custom_url_path}/${var_custom_preseed_id} ${var_install_tmp_path} ${_var_after_install_script_name};
    chmod +x ${var_install_tmp_path}/${_var_after_install_script_name};

    # download run-once.sh to '/usr/local/bin' and set as executable
    _fn_download_file ${_var_shared_url_path} ${_var_run_once_script_path} ${_var_run_once_script_name};
    chmod +x ${_var_run_once_script_path}/${_var_run_once_script_name};

    # download run-once.service to '/etc/systemd/system'
    _fn_download_file ${_var_shared_url_path} ${_var_run_once_unit_path} ${_var_run_once_unit_name};
    # enable run-once.service service
    systemctl enable ${_var_run_once_unit_name};
}

fn_bootstrap;