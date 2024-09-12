{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./base-configuration.nix
        # ./drivers/fanatec.nix
        ./desktop/gnome.nix
    ];

    # Hostname
    networking.hostName = "nix-mac";

    # Configure keyboard variant
    services.xserver.xkb.variant = "mac";

    # Additionnal Users
    users.users.ruthanna = {
        isNormalUser = true;
        description = "Ruthanna";
        extraGroups = [ "networkmanager" "scanner" "lp" ];
    };

    # Initial installation version (should not be modified)
    system.stateVersion = "24.05";
}
