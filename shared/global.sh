#!/usr/bin/env bash
# name=shared/global.sh
# version=1.0.0

# preseed url root
_var_url_root='https://raw.githubusercontent.com/ewalbridge/di-preseed/main';

## url paths
# shared url path
_var_shared_url_path='shared';
# custom url path
_var_custom_url_path='custom';

## during and after script names
# during install script name
_var_during_install_script_name='during-install.sh';
# after install script name
_var_after_install_script_name='after-install.sh';

## run once unit
# run once systemd unit name
_var_run_once_unit_name='run-once.service';
# run once systemd unit path
_var_run_once_unit_path='/etc/systemd/system'; #'/etc/systemd/system';

## run once script
# run once script name
_var_run_once_script_name='run-once.sh';
# run once script path
_var_run_once_script_path='/usr/local/bin'; #'/usr/local/bin';

_fn_logger () {    
    logger 'di-preseed:' ${1};
}

# shared download function
_fn_download_file () {
    # 'shared' or 'custom preseed id'
    local url_path=${1};

    # save file to this location
    local save_path=${2};

    # file name to download and save
    local file_name=${3};

    # download file to location
    wget ${_var_url_root}/${url_path}/${file_name} --output-document=${save_path}/${file_name};
}
