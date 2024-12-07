{ config, pkgs, lib, ... }:

with lib;
{
    imports = [
        ./firefox.nix
    ];
    # programs.firefox.enable = true;

    environment.systemPackages = with pkgs; [
        bitwarden
        discord
        # gparted
        # libreoffice
        # hunspell
        # hunspellDicts.fr-moderne
    ];
}
