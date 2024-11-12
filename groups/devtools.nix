{ config, pkgs, lib, ... }:

{
    programs.git.enable = true;

    environment.systemPackages = with pkgs; [
        vscodium
        gnumake
        python3
        python3Packages.requests
        python3Packages.pygobject3
    ];
}