#!/usr/bin/env bash
# name=shared/core-dhcpclient.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh
# log name of script
_fn_logger 'shared/core-dhcpclient.sh';
### INCLUDE ###

fn_replace_dhcpclient () {
    apt install -y 'dhcpcd5';
    apt purge -y 'isc-dhcp-client isc-dhcp-common';
}

fn_replace_dhcpclient;
