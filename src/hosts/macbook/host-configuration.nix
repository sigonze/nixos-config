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
        initrd.kernelModules = [ "wl" ];
        kernelModules = [ "wl" "applesmc" ];
        #kernelParams = [ "hid_apple.iso_layout=0" "acpi_backlight=vendor" "acpi_mask_gpe=0x15" ];
        extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    };

    # Add Intel Haswell codecs
    nixpkgs.config.packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
            vaapiIntel
            vaapiVdpau
            libvdpau-va-gl
            intel-media-driver
        ];
    };

    # Fix GTK Haswell support
    environment.variables = {
        GSK_RENDERER = "ngl";
        # LIBVA_DRIVER_NAME = "iHD";
    };

    # Select Apps
    apps.devtools = true;

    # Initial installation version (should not be modified)
    system.stateVersion = "25.05";
}
