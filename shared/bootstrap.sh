#!/usr/bin/env bash
# name=shared/bootstrap.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
install_tmp_path='/root/tmp';
# reference global
. ${install_tmp_path}/global.sh
### INCLUDE ###


# preseed identifier
custom_preseed=custom/${1};

# download and start custom install functions
# this is called from preseed.cfg d-i preseed/late_command
fn_bootstrap () {
    # /etc/systemd/system
    _download_file 'shared' '/root/tmp' ${_var_run_once_unit_name};
    # /usr/local/bin
    _download_file 'shared' '/root/tmp' ${_var_run_once_script_name};
    _download_file ${custom_preseed} ${install_tmp_path} ${_var_during_install_script_name};
    _download_file ${custom_preseed} ${install_tmp_path} ${_var_after_install_script_name};
}

fn_bootstrap;