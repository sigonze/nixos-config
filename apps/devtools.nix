{ config, pkgs, lib, ... }:

{
    programs.git.enable = true;

    environment.systemPackages = with pkgs; [
        vscodium
        gnumake
        (python3.withPackages(ps: with ps; [
            requests
            pygobject3
        ]))
    ];

    # nix.settings.experimental-features = [ "nix-command" "flakes" ];
}