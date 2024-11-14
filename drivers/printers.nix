{ config, pkgs, lib, extra-config, ... }:
let
    extra-printers = map(pkg: pkgs."${pkg}") extra-config.printers or [];
    users-list = builtins.attrNames config.users.users;
in
{
    # Configure printer
    services.printing = {
        enable = true;
        drivers = extra-printers;
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