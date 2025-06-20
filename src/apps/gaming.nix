{ config, pkgs, lib, ... }:

let
    all-users = builtins.attrNames config.users.users;
    normal-users = builtins.filter (user: config.users.users.${user}.isNormalUser == true) all-users;
in
{
    options.apps = {
        gaming = lib.mkOption {
            type = with lib.types; bool;
            default = false;
            description = "Install gaming apps";
        };
    };

    config = lib.mkIf config.apps.gaming {
        programs = {
            gamemode.enable = true;
            gamescope.enable = true;

            steam = {
                enable = true;
                gamescopeSession.enable = true;
                remotePlay.openFirewall = true;
                extraCompatPackages = with pkgs; [
                    proton-ge-bin
                ];
            };

        };

        # Gaming apps
        environment.systemPackages = with pkgs; [
            game-devices-udev-rules
            heroic
            mangohud
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

        # Environment variables for steam (needed for proton-ge && mangohud)
        environment.sessionVariables = {
            STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
        };

        # add all users to group gamemode
        users.groups.gamemode = {
            members = normal-users;
        };
    };
}