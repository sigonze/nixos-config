{ config, pkgs, lib, ... }:

let
    fanatecff = config.boot.kernelPackages.callPackage ./hid-fanatecff {};
    users-list = builtins.attrNames config.users.users;
in
{
    boot.extraModulePackages = [ fanatecff ];
    services.udev.packages = [ fanatecff ];
    boot.kernelModules = [ "hid-fanatec" ];

    environment.systemPackages = with pkgs; [
        linuxConsoleTools                       # needed by udev rules
    ];

    # add all user to games group (to grant r/w on sysfs)
    users.groups.games = {
        members = users-list;
    };
}