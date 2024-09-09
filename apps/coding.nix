{ config, pkgs, ... }:

{
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
        gnumake
        gcc
        vscodium
    ];
}