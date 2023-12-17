#!/usr/bin/env bash
# name=shared/global.sh
# version=1.0.0

# preseed identifier
__custom_preseed=custom/${1};

# preseed url root
_var_url_root='https://raw.githubusercontent.com/ewalbridge/di-preseed/main';

# temp install file location
_var_install_tmp_path='/root/tmp';

# run once systemd unity name
_var_run_once_unit_name='run-once.service';

# run once script name
_var_run_once_script_name='run-once.sh';

# download and start custom install functions
# this is called from preseed.cfg d-i preseed/late_command
_fn_bootstrap () {
    # /etc/systemd/system
    _download_file 'shared' '/root/tmp' ${_var_run_once_unit_name};
    # /usr/local/bin
    _download_file 'shared' '/root/tmp' ${_var_run_once_script_name};
    _download_file ${__custom_preseed} ${_var_install_tmp_path} 'during-install.sh';
    _download_file ${__custom_preseed} ${_var_install_tmp_path} 'after-install.sh';
}

_download_file () {
    local url_location=${1};
    local save_to_path=${2};
    local file_name=${3};
    local download_from_url=${_var_url_root}/${url_location}/${file_name};
    echo wget -O ${download_from_url} ${save_to_path}/${file_name};
    wget ${download_from_url} -O ${save_to_path}/${file_name};
}

_fn_bootstrap;
