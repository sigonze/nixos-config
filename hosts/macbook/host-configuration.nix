{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Hostname
    networking.hostName = "nix-mac";

    # Users
    users.users.nicolas = {
        isNormalUser = true;
        description = "Nicolas";
        extraGroups = [ "networkmanager" "wheel" ];
    };

    users.users.ruthanna = {
        isNormalUser = true;
        description = "Ruthanna";
        extraGroups = [ "networkmanager" ];
    };

    # hardware.facetimehd.enable = true;

    # Configure keyboard variant
    services.xserver.xkb.variant = "mac";

    # Select Apps
    apps.devtools = true;

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
