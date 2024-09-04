{ config, pkgs, lib, ... }:

let fanatecff = config.boot.kernelPackages.callPackage ./hid-fanatecff {};
in
{
    boot.extraModulePackages = [ fanatecff ];
    services.udev.packages = [ fanatecff ];
    boot.kernelModules = [ "hid-fanatec" ];
    users.groups.games = {};                    # needed by udev rules

    environment.systemPackages = with pkgs; [
        linuxConsoleTools                       # needed by udev rules
    ];
}