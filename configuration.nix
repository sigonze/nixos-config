{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./drivers/fanatec.nix
        ./conf/common.nix
        ./desktop/gnome.nix
        ./apps/base.nix
        ./apps/coding.nix
        # replaced by flatpak apps
        # ./apps/essentials.nix
        # ./apps/gaming.nix
    ];

    # Hostname
    networking.hostName = "nix-gaming";

    # Select Kernel
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # Change default governor
    powerManagement.cpuFreqGovernor = "schedutil";

    # amd-pstate
    boot.kernelParams = [ "amd_pstate=active" ];

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };

    # Configure keyboard variant
    services.xserver.xkb.variant = "oss";

    # Activate Flatpak
    services.flatpak.enable = true;

    # Packages
    environment.systemPackages = with pkgs; [
        game-devices-udev-rules     # gamepads
    ];

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
