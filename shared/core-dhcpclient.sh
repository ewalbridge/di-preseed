#!/usr/bin/env bash
# name=shared/core-btrfs.sh
# version=1.0.0

### INCLUDE ###
# temp install file location
var_install_tmp_path='/root/tmp';
# reference global
. ${var_install_tmp_path}/global.sh
# log name of script
_fn_logger 'shared/core-btrfs.sh';
### INCLUDE ###