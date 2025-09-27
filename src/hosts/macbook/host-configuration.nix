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
    powerManagement.enable = true;
    # powerManagement.cpuFreqGovernor = "schedutil";
    services.mbpfan.enable = true;
    hardware.cpu.intel.updateMicrocode = true;

    # Add Wifi
    nixpkgs.config.allowInsecurePredicate = pkg: builtins.elem (lib.getName pkg) [
        "broadcom-sta"
    ];
    boot.initrd.kernelModules = [ "wl" ];
    boot.kernelModules = [ "wl" "applesmc" "i915" ];
    # boot.kernelParams = [ "hid_apple.iso_layout=0" "acpi_backlight=vendor" "acpi_mask_gpe=0x15" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

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
    };

    # Select Apps
    apps.devtools = true;

    # Initial installation version (should not be modified)
    system.stateVersion = "25.05";
}
