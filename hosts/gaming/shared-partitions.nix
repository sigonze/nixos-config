{ config, lib, pkgs, ... }:

{
    fileSystems."/mnt/Games" = {
        device = "/dev/disk/by-label/Games";
        fsType = "ext4";
        options = [
            # "users"
            "x-gvfs-hide"
            "nofail"
        ];
    };
}