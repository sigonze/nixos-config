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
        hardware.gaming.enable = true;

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
            heroic
            mangohud
            # protonplus
            # protontricks
        ];

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