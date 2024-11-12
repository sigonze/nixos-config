{ config, pkgs, ... }:

{
    imports = [
        ./groups/devtools.nix
        ./groups/gaming.nix
        ./drivers/fanatec.nix
    ];

    # Hostname
    networking.hostName = "nix-gaming";

    # Users
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    # Configure keyboard variant
    services.xserver.xkb.variant = "oss";

    # Select Kernel
    # boot.kernelPackages = pkgs.linuxPackages_xanmod;
    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    boot.kernelPackages = pkgs.linuxPackages_lqx;
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # amd-pstate
    boot.kernelParams = [ "amd_pstate=active" ];

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };


    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
