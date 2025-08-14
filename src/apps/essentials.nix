{ config, pkgs, lib, ... }:

with lib;
{
    options.apps = {
        essentials = mkOption {
            type = with types; bool;
            default = true;
            description = "Install essentials apps";
        };
    };

    config = mkIf config.apps.essentials {
        programs.firefox = {
            enable = true;
            package = pkgs.firefox-esr;
        };

        environment.systemPackages = with pkgs; [
            bitwarden
            discord
            calibre
            libreoffice
            hunspell
            hunspellDicts.fr-any
        ];
    };
}
