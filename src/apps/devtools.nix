{ config, pkgs, lib, ... }:

with lib;
{
    options.apps = {
        devtools = mkOption {
            type = types.bool;
            default = false;
            description = "Install development tools";
        };
    };

    config = mkIf config.apps.devtools {
        programs.git.enable = true;

        environment.systemPackages = with pkgs; [
            vscodium
            gnumake
            (python3.withPackages(ps: with ps; [
                requests
                pygobject3
            ]))
        ];
    };
}