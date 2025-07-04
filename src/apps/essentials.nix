{ config, pkgs, lib, ... }:

with lib;
{
    imports = [
        ./config/firefox.nix
    ];

    options.apps = {
        essentials = mkOption {
            type = with types; bool;
            default = true;
            description = "Install essentials apps";
        };
    };

    config = mkIf config.apps.essentials {
        programs.firefox.enable = true;

        environment.systemPackages = with pkgs; [
            bitwarden
            calibre
            libreoffice
            hunspell
            hunspellDicts.fr-any
        ];
    };
}
