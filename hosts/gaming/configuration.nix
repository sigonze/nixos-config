{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./base-configuration.nix
        ./drivers/fanatec.nix
        ./desktop/gnome.nix
        ./apps/coding.nix
        # replaced by flatpak apps
        # ./apps/essentials.nix
        # ./apps/gaming.nix
    ];

    # Hostname
    networking.hostName = "nix-gaming";

    # Configure keyboard variant
    services.xserver.xkb.variant = "oss";

    # Select Kernel
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # boot.kernelPackages = pkgs.linuxPackages_latest;

    # Change default governor
    powerManagement.cpuFreqGovernor = "schedutil";

    # amd-pstate
    boot.kernelParams = [ "amd_pstate=guided" ];

    # Configure zram
    zramSwap.priority = 100;
    boot.kernel.sysctl = {  "vm.swappiness" = 10; };

    # Enable Gamemode
    programs.gamemode.enable = true;

    # Update user group for fanatec wheel && gamemode
    users.users.nicolas.extraGroups =  [ "games" "gamemode" ];

    # Packages
    environment.systemPackages = with pkgs; [
        game-devices-udev-rules     # gamepads
    ];

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
