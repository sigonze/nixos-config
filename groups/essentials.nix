{ config, pkgs, lib, ... }:

{
    programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
        bitwarden
        discord
        # libreoffice
        # hunspell
        # hunspellDicts.fr-moderne
    ];
}
