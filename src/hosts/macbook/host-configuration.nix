{ config, pkgs, lib, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Hostname
    networking.hostName = "macbook";

    # Users
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" ];
    };

#    users.users.ruthanna = {
#        isNormalUser = true;
#        description = "Ruthanna";
#        extraGroups = [ "networkmanager" ];
#    };

    # hardware.facetimehd.enable = true;

    # Configure keyboard variant
    services.xserver.xkb.variant = "mac";

    services.acpid.enable = true;
    powerManagement = {
        enable = true;
        # cpuFreqGovernor = "schedutil";
        powertop.enable = true;
    };
    # services.auto-cpufreq.enable = true;
    # networking.networkmanager.wifi.powersave = true;
    services.thermald.enable = true;
    services.mbpfan = {
        enable = true;
        aggressive = false;
    };

    # Add Wifi
    nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
        "broadcom-sta"
    ];

    boot = {
        initrd.kernelModules = [ "wl" "i915" ];
        kernelModules = [ "wl" "applesmc" ];
        extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    };

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            intel-vaapi-driver
            intel-ocl
            intel-media-driver
            intel-compute-runtime
            vpl-gpu-rt
        ];
    };

    # Select Apps
    apps.devtools = true;

    # Initial installation version (should not be modified)
    system.stateVersion = "25.05";
}
