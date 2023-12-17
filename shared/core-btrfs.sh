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

# assumes only one device partition formatted with btrfs
var_block_device_path="$(blkid | grep btrfs | awk -F':' '{ print $1 }')";
var_block_device_uuid="$(blkid -s UUID -o value ${var_block_device_path})";
var_btrfs_mount_path="/mnt";
var_fstab_path="/etc/fstab";

# rename btrfs rootfs
fn_rename_btrfs_rootfs () {

    # rename @rootfs to @
    mv ${var_btrfs_mount_path}/@rootfs ${var_btrfs_mount_path}/@;
   
    # rename @rootfs to @ in fstab and grub.cfg
    sed -i 's/@rootfs/@/g' /etc/fstab;
    sed -i 's/@rootfs/@/g' /boot/grub/grub.cfg;

    # run update-grub
    update-grub;
}

# modify tmp
fn_create_btrfs_tmp () {

    local dir_name="tmp";

    # create fstab entry
    echo "UUID=${var_block_device_uuid} /${dir_name}           btrfs   defaults,subvol=@${dir_name} 0      0" >> ${var_fstab_path};

    # create btrfs subvolume
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name};

    # rename /tmp /tmp.backup
    mv /${dir_name} /${dir_name}.backup;

    # create /tmp
    mkdir /${dir_name} ;

    # mount subvolume
    mount /${dir_name};

    # copy /tmp.backup to /tmp
    cp -a /${dir_name}.backup/* /${dir_name};

    # delete /tmp.backup
    rm -rf /${dir_name}.backup;

    systemctl daemon-reload;
}

# modify home
fn_create_btrfs_home () {

    local dir_name="home";

    # create fstab entry
    echo "UUID=${var_block_device_uuid} /${dir_name}           btrfs   defaults,subvol=@${dir_name} 0      0" >> ${var_fstab_path};

    # create btrfs subvolume
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name};

    # rename /home /home.backup
    mv /${dir_name} /${dir_name}.backup;

    # create /home
    mkdir /${dir_name} ;

    # mount subvolume
    mount /${dir_name};

    # copy /home.backup to /home
    cp -a /${dir_name}.backup/* /${dir_name};

    # delete /home.backup
    rm -rf /${dir_name}.backup;

    systemctl daemon-reload;
}

# modify var, this will break apt (missing start-stop-daemon), fix below
fn_create_btrfs_var () {

    local dir_name="var";

    # create fstab entries
    echo "UUID=${var_block_device_uuid} /${dir_name}            btrfs   defaults,subvol=@${dir_name} 0      0" >> ${var_fstab_path};
    echo "UUID=${var_block_device_uuid} /${dir_name}/log        btrfs   defaults,subvol=@${dir_name}-log 0      0" >> ${var_fstab_path};
    echo "UUID=${var_block_device_uuid} /${dir_name}/log/audit  btrfs   defaults,subvol=@${dir_name}-log-audit 0      0" >> ${var_fstab_path};
    echo "UUID=${var_block_device_uuid} /${dir_name}/tmp        btrfs   defaults,subvol=@${dir_name}-tmp 0      0" >> ${var_fstab_path};

    # create btrfs subvolumes
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name};
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name}-log;
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name}-log-audit;
    btrfs subvolume create ${var_btrfs_mount_path}/@${dir_name}-tmp;

    # disable copy-on-write /var/log
    chattr +C ${var_btrfs_mount_path}/@${dir_name}-log;

    # rename /var /var.backup
    mv /${dir_name} /${dir_name}.backup;

    # create /var
    mkdir /${dir_name};

    # create mount sub directories
    mkdir ${var_btrfs_mount_path}/@${dir_name}/log;
    mkdir ${var_btrfs_mount_path}/@${dir_name}-log/audit;
    mkdir ${var_btrfs_mount_path}/@${dir_name}/tmp;

    # mount subvolumes
    mount /${dir_name};
    mount /${dir_name}/log;
    mount /${dir_name}/log/audit;
    mount /${dir_name}/tmp;
    systemctl daemon-reload;

    # copy /var.backup to /var
    cp -a /${dir_name}.backup/* /${dir_name};

    # delete /var.backup
    rm -rf /${dir_name}.backup;

    systemctl daemon-reload;
}

# mount temporary btrfs volume
mount ${var_block_device_path} ${var_btrfs_mount_path};

fn_rename_btrfs_rootfs;
fn_create_btrfs_tmp;
fn_create_btrfs_home;
fn_create_btrfs_var;

umount ${var_block_device_path};
