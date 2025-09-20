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
}
