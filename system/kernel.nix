{ config, pkgs, lib, extra-config, ... }:

let
    kernel-packages = {
        "xanmod" = pkgs.linuxPackages_xanmod;
        "xanmod_latest" = pkgs.linuxPackages_xanmod_latest;
        "lqx" = pkgs.linuxPackages_lqx;
        "latest" = pkgs.linuxPackages_latest;
        "default" = pkgs.linuxPackages;
    };
    selected-kernel = builtins.getAttr (extra-config.kernel or "default") kernel-packages;
    extra-kernel-options = extra-config.kernel-options or [];
in
{
    boot.kernelPackages = selected-kernel;
    boot.kernelParams = extra-kernel-options;
}
