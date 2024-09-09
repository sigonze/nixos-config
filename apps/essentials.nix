{ config, pkgs, ... }:

{
    programs.firefox = {
        enable = true;
        languagePacks = [ "fr" ];
    };

    environment.systemPackages = with pkgs; [
        bitwarden
        discord
        libreoffice
        aspell
        aspellDicts.fr
        calibre
    ];
}