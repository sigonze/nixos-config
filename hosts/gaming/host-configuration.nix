{ config, pkgs, ... }:

{
    imports = [
        ./shared-partitions.nix
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
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelPackages = pkgs.linuxPackages_zen;
    # boot.kernelPackages = pkgs.linuxPackages_lqx;
    boot.kernelPackages = pkgs.linuxPackages_xanmod;
    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # amd-pstate
    boot.kernelParams = [ "amd_pstate=active" ];

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };

    # Enable Fanatec Wheel
    hardware.fanatec.enable = true;

    # Steam Hardware
    # hardware.steam-hardware.enable = true;

    # Select Apps
    apps.devtools = true;
    apps.gaming = true;

    # Initial installation version (should not be modified)
    system.stateVersion = "24.11";
}
