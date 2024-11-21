{ config, pkgs, ... }:

{
    imports = [
        ./apps/devtools.nix
    ];

    # Hostname
    networking.hostName = "nix-mac";

    # Enable zram
    zramSwap.enable = true;

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

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
