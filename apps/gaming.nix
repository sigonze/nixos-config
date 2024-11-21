{ config, pkgs, lib, ... }:

let
    all-users = builtins.attrNames config.users.users;
    normal-users = builtins.filter (user: config.users.users.${user}.isNormalUser == true) all-users;
in
{
    # Enable opengl drivers
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    # Enable Gamemode
    programs.gamemode.enable = true;

    # Steam
    # hardware.steam-hardware.enable = true;
    programs.steam = {
        enable = true;
        # package = pkgs.steam.override { extraEnv = { MANGOHUD = 1; }; };
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    };

    # Gaming apps
    environment.systemPackages = with pkgs; [
        # protonplus
        # protontricks
        mangohud
        vulkan-tools
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

    # Environmant varaibles for steam (needed for proton-ge && mangohud)
    environment.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS="\${HOME}/.steam/root/compatibilitytools.d";
        MANGOHUD_CONFIG="horizontal,hud_no_margin,cpu_stats,ram,gpu_name,gpu_stats,vram,fps,frametime=0,frame_timing=0,time,time_format=%H\\:%M";
    };

    # add all users to group gamemode
    users.groups.gamemode = {
        members = normal-users;
    };
}