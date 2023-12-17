#!/usr/bin/env bash
# name=shared/global.sh
# version=1.0.0

# preseed url root
_var_url_root='https://raw.githubusercontent.com/ewalbridge/di-preseed/main';

# run once systemd unity name
_var_run_once_unit_name='run-once.service';

# run once script name
_var_run_once_script_name='run-once.sh';

# during install script name
_var_during_install_script_name='during-install.sh';

# after install script name
_var_after_install_script_name='after-install.sh';

_download_file () {
    # "shared" or "custom/id"
    local url_path=${1};
    # save file to this location
    local save_to_path=${2};
    # file name to download and save
    local file_name=${3};
    # full file url path to download
    local download_from_url=${_var_url_root}/${url_path}/${file_name};
    # doanload file to location
    wget ${download_from_url} -O ${save_to_path}/${file_name};
}
