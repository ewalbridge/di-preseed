#!/usr/bin/env bash
# name=shared/run-once.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh
# log name of script
_fn_logger 'shared/run-once.sh';
### INCLUDE ###

fn_run_after_install_script () {
    # run after-install.sh
    ${var_install_tmp_path}/${_var_after_install_script_name};
}

fn_self_cleanup () {
    # diasable run-once.service service 
    systemctl disable ${_var_run_once_unit_name};
    # delete run-once.service unit
    rm ${_var_run_once_unit_path}/${_var_run_once_unit_name};
    # delete run-once.sh script
    rm ${_var_run_once_script_path}/${_var_run_once_script_name};

    # cleanup various install temp files
    rm /.wget-hsts;
    #rm -rf ${var_install_tmp_path};

    # final reboot
    reboot;
}

fn_run_after_install_script;
fn_self_cleanup;
