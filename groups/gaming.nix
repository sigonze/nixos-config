{ config, pkgs, lib, ... }:

let
    all-users = builtins.attrNames config.users.users;
    normal-users = builtins.filter (user: config.users.users.${user}.isNormalUser == true) all-users;
in
{
    # Enable opengl drivers
    hardware.opengl = {
        enable = true;
        driSupport = true;
        # driSupport32Bit = true;
    };

    # Enable Gamemode
    programs.gamemode.enable = true;

    # Steam device
    hardware.steam-hardware.enable = true;

    # Rules to disable Dualshock touchpad
    services.udev.extraRules = ''
        # USB
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Bluetooth
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    # add all users to group gamemode
    users.groups.gamemode = {
        members = normal-users;
    };
}