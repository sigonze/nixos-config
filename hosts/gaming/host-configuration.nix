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
    # boot.kernelPackages = pkgs.linuxPackages_xanmod;
    # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

    # Use system-wide overlays to override linux-firmware
    nixpkgs.overlays = [
      (final: prev: {
        linux-firmware = prev.linux-firmware.overrideAttrs (old: rec {
          version = "20250509";
          src = prev.fetchzip {
            url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
            hash = "sha256-0FrhgJQyCeRCa3s0vu8UOoN0ZgVCahTQsSH0o6G6hhY=";
          };
        });
      })
    ];

    # amd-pstate
    boot.kernelParams = [ 
        "amd_pstate=active"
    ];

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
