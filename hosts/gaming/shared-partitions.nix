{ config, lib, pkgs, ... }:

{
    fileSystems = {
        "/home" = {
            device = "/dev/disk/by-label/home";
            fsType = "ext4";
            options = [
                "x-gvfs-hide"
                "nofail"
            ];
        };
        "/home/nicolas/Games" = {
            device = "/dev/disk/by-label/games";
            fsType = "ext4";
            options = [
                # "users"
                "x-gvfs-hide"
                "nofail"
            ];
        };
    };

    swapDevices = [{ 
        device = "/dev/disk/by-uuid/5beb1706-07b4-4234-98c4-03fc1ccea0d8";
        options = [
            "nofail"
        ];
    }];
}
