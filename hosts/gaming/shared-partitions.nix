{ config, lib, pkgs, ... }:

{
    fileSystems = {
        "/mnt/Games" = {
            device = "/dev/disk/by-label/Games";
            fsType = "ext4";
            options = [
                # "users"
                "x-gvfs-hide"
                "nofail"
            ];
        };
        "/mnt/Data" = {
            device = "/dev/disk/by-label/Data";
            fsType = "ext4";
            options = [
                "x-gvfs-hide"
                "nofail"
            ];
        };
    };

    swapDevices = [{ 
        device = "/dev/disk/by-uuid/99b04311-27d2-460a-b516-1d97af59fb61";
        options = [
            "nofail"
        ];
    }];
}