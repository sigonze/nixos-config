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
        driSupport32Bit = true;
    };

    # Enable Gamemode
    programs.gamemode.enable = true;

    # Steam
    #hardware.steam-hardware.enable = true;
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };

    # Gaming apps
    environment.systemPackages = with pkgs; [
        # protonplus
        # protontricks
        mangohud
        goverlay
        # heroic
    ];

    # Rules to disable Dualshock touchpad
    services.udev.extraRules = ''
        # USB
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Sony Interactive Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        # Bluetooth
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';

    environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        MANGOHUD = 1;
    };

    # add all users to group gamemode
    users.groups.gamemode = {
        members = normal-users;
    };
}