{ config, pkgs, lib, ... }:

with lib;
{
    imports = [
        ./config/firefox.nix
    ];

    options.apps = {
        essentials = mkOption {
            type = with types; bool;
            # default = true;
            default = false;
            description = "Install essentials apps";
        };
    };

    config = mkIf config.apps.essentials {
        programs.firefox.enable = true;

        environment.systemPackages = with pkgs; [
            bitwarden
            # discord
            # libreoffice
            # hunspell
            # hunspellDicts.fr-any
        ];
    };
}
