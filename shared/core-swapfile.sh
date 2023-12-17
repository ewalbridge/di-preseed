#!/usr/bin/env bash
# name=shared/core-swapfile.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh;
# log name of script
_fn_logger 'shared/core-swapfile.sh';
### INCLUDE ###

# create swapfile
# reference=https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/ch-swapspace
fn_create_swapfile () {

    local custom_bytes=${1};
    local kilobyte=1024;
    local swap_bytes=0;
    local memory_bytes=$(free -b | grep 'Mem:' | awk '{ print $2 }');
    local gigabyte_1=$((${kilobyte}**3));
    local gigabyte_2=$((${gigabyte_1}*2));
    local gigabyte_4=$((${gigabyte_1}*4));
    local gigabyte_8=$((${gigabyte_1}*8));
    local swap_path="/.swapfile";

    # set byte size dynamically
    if [ ${memory_bytes} -lt ${gigabyte_2} ]; then
        # swap is double memory
        swap_bytes=$((${memory_bytes}*2));

    elif [[ ${memory_bytes} -ge ${gigabyte_2} && ${memory_bytes} -lt ${gigabyte_4} ]]; then
        # swap is 4 GB
        swap_bytes=${gigabyte_4};

    elif [[ ${memory_bytes} -ge ${gigabyte_4} && ${memory_bytes} -lt ${gigabyte_8} ]]; then
        # swap is equal to memory
        swap_bytes=${memory_bytes};

    else
        # at least 4 GB (manually adjust if necessary after install)
        swap_bytes=${gigabyte_4};
    fi

    # must run after dynamic size if statement
    # apply custome size if defined in param
    if ! [ -z ${custom_bytes} ]; then
        swap_bytes=${custom_bytes};
    fi

    btrfs filesystem mkswapfile -s $((${swap_bytes}/${kilobyte}))k ${swap_path};
    echo "${swap_path}      none            swap    sw       0      0" >> "/etc/fstab";
}

fn_create_swapfile;
