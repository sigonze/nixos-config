{ config, lib, pkgs, ... }:

{
    fileSystems."/home/nicolas/Games" = {
        device = "/dev/disk/by-label/games";
        fsType = "ext4";
        options = [
            # "users"
            "x-gvfs-hide"
            "nofail"
        ];
    };
}