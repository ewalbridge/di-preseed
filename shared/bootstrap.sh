#!/usr/bin/env bash
# name=shared/bootstrap.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh
### INCLUDE ###


# preseed identifier
custom_preseed=custom/${1};

# download and start custom install functions
# this is called from preseed.cfg d-i preseed/late_command
fn_bootstrap () {
    # /etc/systemd/system
    _fn_download_file ${_shared_url_path} '/root/tmp' ${_var_run_once_unit_name};
    # /usr/local/bin
    _fn_download_file ${_shared_url_path} '/root/tmp' ${_var_run_once_script_name};
    _fn_download_file ${custom_preseed} ${install_tmp_path} ${_var_during_install_script_name};
    _fn_download_file ${custom_preseed} ${install_tmp_path} ${_var_after_install_script_name};
}

fn_bootstrap;