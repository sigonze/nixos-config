{ config, pkgs, ... }:

{
    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
            proton-ge-bin
        ];
    }; 

    programs.gamemode.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
        game-devices-udev-rules     # gamepads
        heroic
    ];
}