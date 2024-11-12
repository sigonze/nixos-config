{ config, pkgs, lib,  ... }:
let
    users-list = builtins.attrNames config.users.users;
in
{
    # Configure printer
    services.printing = {
        enable = true;
        startWhenNeeded = true;
    };

    # Enable autodiscovery
    services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
    };

    # systemd.services.cups-browsed.enable = false;
    hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
    };

    # add all users to group scanner and lp
    users.groups.scanner = {
        members = users-list;
    };
    users.groups.lp = {
        members = users-list;
    };
}