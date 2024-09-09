{ config, pkgs, ... }:

{
    programs.git.enable = true;
    environment.systemPackages = with pkgs; [
        vim
        gnumake
        gcc
        vscodium
    ];
}