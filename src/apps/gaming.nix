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
            # Gamemode
            gamemode.enable = true;

            # Gamescope
            gamescope = {
                enable = true;
                capSysNice = true;
            };

            # Steam
            # hardware.steam-hardware.enable = true;
            steam = {
                enable = true;
                # package = pkgs.steam.override { extraEnv = { MANGOHUD = 1; }; };
                # gamescopeSession.enable = true;
                remotePlay.openFirewall = true;
                extraCompatPackages = with pkgs; [
                    proton-ge-bin
                ];
            };

        };

        # Gaming apps
        environment.systemPackages = with pkgs; [
            game-devices-udev-rules
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
            # MANGOHUD_CONFIG = "control=mangohud,legacy_layout=0,horizontal,battery,time,time_format=%H\\:%M,gpu_stats,gpu_power,cpu_stats,ram,vram,fps,frametime=1,frame_timing=1,hud_no_margin,table_columns=14";
        };

        # add all users to group gamemode
        users.groups.gamemode = {
            members = normal-users;
        };
    };
}