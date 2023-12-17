#!/usr/bin/env bash
# name=shared/global.sh
# version=1.0.0

# preseed identifier
__custom_preseed=custom/${1};

# preseed url root
_var_url_root='https://raw.githubusercontent.com/ewalbridge/di-preseed/main';

# temp install file location
_var_install_tmp_path='/root/tmp';

# download and start custom install functions
# this is called from preseed.cfg d-i preseed/late_command
_fn_bootstrap () {
    _download_file 'shared' 'run-once.sh';
    _download_file ${__custom_preseed} 'during-install.sh';
    _download_file ${__custom_preseed} 'after-install.sh';
}

_download_file () {
    local url_location=${1};
    local file_name=${2};
    local download_from_url=${_var_url_root}/${url_location}/${file_name};
    local save_to_path=${_var_install_tmp_path}/${file_name};
    wget -O ${download_from_url} ${save_to_path};
}

_fn_bootstrap;
